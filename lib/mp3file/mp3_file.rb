module Mp3file
  class InvalidMP3FileError < Mp3fileError; end

  class MP3File
    attr_reader(:file, :file_size, :audio_size)
    attr_reader(:first_header_offset, :first_header)
    attr_reader(:xing_header_offset, :xing_header)
    attr_reader(:vbri_header_offset, :vbri_header)
    attr_reader(:mpeg_version, :layer, :bitrate, :samplerate, :mode)
    attr_reader(:num_frames, :total_samples, :length)

    attr_accessor(:id3v1_tag, :id3v2_tag, :extra_id3v2_tags)

    def initialize(file_path, options = {})
      file_path = Pathname.new(file_path).expand_path if file_path.is_a?(String)
      load_file(file_path, options)
    end

    def vbr?
      @vbr
    end

    def id3v1tag?
      !@id3v1_tag.nil?
    end

    def id3v2tag?
      !@id3v2_tag.nil?
    end

    def title
      value_from_tags(:title)
    end

    def artist
      value_from_tags(:artist)
    end

    def album
      value_from_tags(:album)
    end

    def track
      value_from_tags(:track)
    end

    def year
      value_from_tags(:year)
    end

    def comment
      value_from_tags(:comment)
    end

    def genre
      value_from_tags(:genre)
    end

    def each_header
      file = File.open(@file.path, "rb")
      offset = @first_header_offset

      file.seek(offset, IO::SEEK_SET)
      while !file.eof?
        header = MP3Header.new(file)
        yield offset, header

        offset = offset + header.frame_size
        file.seek(offset, IO::SEEK_SET)
      end

      file.close
    end

    private

    def value_from_tags(v1_field)
      if @id3v1_tag
        @id3v1_tag.send(v1_field)
      else
        nil
      end
    end

    def load_file(file_path, options = {})
      scan_all_headers = %w{ t true 1 }.include?(options[:scan_all_headers].to_s)

      @file = file_path.open('rb')
      @file.seek(0, IO::SEEK_END)
      @file_size = @file.tell

      # Try to read an ID3v1 tag.
      @id3v1_tag = nil
      begin
        @file.seek(-128, IO::SEEK_END)
        @id3v1_tag = ID3v1Tag.parse(@file)
      rescue Mp3file::InvalidID3v1TagError
        @id3v1_tag = nil
      ensure
        @file.seek(0, IO::SEEK_SET)
      end

      # Try to detect an ID3v2 header.
      @id3v2_tag = nil
      begin
        @id3v2_tag = ID3v2::Tag.new(@file)
      rescue ID3v2::InvalidID3v2TagError # => e
        # $stderr.puts "Error parsing ID3v2 tag: %s\n\t%s" %
        #   [ e.message, e.backtrace.join("\n\t") ]
        @id3v2_tag = nil
        @file.seek(0, IO::SEEK_SET)
      end

      # Skip past the ID3v2 header if it's present.
      if @id3v2_tag
        @file.seek(@id3v2_tag.size, IO::SEEK_SET)
      end

      # Some files have more than one ID3v2 tag. If we can't find an
      # MP3 header in the next 4k, try reading another ID3v2 tag and
      # repeat.
      @extra_id3v2_tags = []
      begin
        # Try to find the first MP3 header.
        @first_header_offset, @first_header = get_next_header(@file)
      rescue InvalidMP3FileError
        end_of_tags = @id3v2_tag.size + @extra_id3v2_tags.map(&:last).map(&:size).reduce(:+).to_i
        @file.seek(end_of_tags, IO::SEEK_SET)

        tag = nil
        begin
          tag = ID3v2::Tag.new(@file)
        rescue ID3v2::InvalidID3v2TagError
          tag = nil
          @file.seek(end_of_tags, IO::SEEK_SET)
        end

        if tag
          @extra_id3v2_tags << [ end_of_tags, tag ]
          retry
        else
          raise
        end
      end

      @mpeg_version = @first_header.version
      @layer = @first_header.layer
      @bitrate = @first_header.bitrate / 1000
      @samplerate = @first_header.samplerate
      @mode = @first_header.mode
      @audio_size = @file_size
      if @id3v1_tag
        @audio_size -= 128
      end
      if @id3v2_tag
        @audio_size -= @id3v2_tag.size
      end

      # If it's VBR, there should be an Xing header after the
      # side_bytes.
      @xing_header = nil
      @file.seek(@first_header.side_bytes, IO::SEEK_CUR)
      begin
        @xing_header = XingHeader.new(@file)
      rescue InvalidXingHeaderError
        @file.seek(@first_header_offset + 4, IO::SEEK_CUR)
      end

      if scan_all_headers
        # Loop through all the frame headers, to check for VBR / CBR (as
        # a Xing header can show up in either case).
        frame_headers = [ @first_header ]
        last_header_offset = @first_header_offset
        loop do
          file.seek(last_header_offset + frame_headers.last.frame_size)
          last_header_offset, header = get_next_header(file)
          if header.nil?
            break
          else
            frame_headers << header
          end
        end

        uniq_brs = frame_headers.map { |h| h.bitrate }.uniq
        @vbr = uniq_brs.size > 1
        if uniq_brs.size == 1
          @bitrate = uniq_brs.first / 1000
        end
      else
        # Use the Xing header to make the VBR / CBR call. Assume that
        # Xing headers, when present in a CBR file, are called "Info".
        @vbr = @xing_header.nil? || @xing_header.name == "Xing"
      end

      if @xing_header && @xing_header.frames && @xing_header.bytes
        # Use the Xing header to calculate the duration (and overall bitrate).
        @num_frames = @xing_header.frames
        @total_samples = @xing_header.frames * @first_header.samples
        @length = total_samples.to_f / @samplerate.to_f
        @bitrate = ((@xing_header.bytes.to_f / @length.to_f) * 8 / 1000)
      else
        # Do the CBR length calculation.
        @num_frames = @audio_size / @first_header.frame_size
        @total_samples = @num_frames * @first_header.samples
        @length = @total_samples.to_f / @samplerate.to_f
      end

      @file.close
    end

    def get_next_header(file, offset = nil)
      if offset && offset != file.tell
        file.seek(offset, IO::SEEK_SET)
      end

      header = nil
      initial_header_offset = file.tell
      header_offset = file.tell

      while header.nil?
        begin
          header = MP3Header.new(file)
          header_offset = file.tell - 4
        rescue InvalidMP3HeaderError
          header_offset += 1
          if header_offset - initial_header_offset > 4096
            raise InvalidMP3FileError, "Could not find a valid MP3 header in the first 4096 bytes."
          else
            file.seek(header_offset, IO::SEEK_SET)
            retry
          end
        rescue EOFError
          break
        end

        # byte = file.readbyte
        # while byte != 0xFF
        #   byte = file.readbyte
        # end
        # header_bytes = [ byte ] + file.read(3).bytes.to_a
        # if header_bytes[1] & 0xE0 != 0xE0
        #   file.seek(-3, IO::SEEK_CUR)
        # else
        #   header = MP3Header.new(header_bytes)
        #   if !header.valid?
        #     header = nil
        #     file.seek(-3, IO::SEEK_CUR)
        #   else
        #     header_offset = file.tell - 4
        #   end
        # end
      end

      # if initial_header_offset != header_offset
      #   puts "Had to skip past #{header_offset - initial_header_offset} to find the next header."
      # end

      [ header_offset, header ]
    end
  end
end
