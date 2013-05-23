module Mp3file
  class InvalidMP3FileError < Mp3fileError; end

  class MP3File
    attr_reader(:file, :file_size, :audio_size)
    attr_reader(:first_header_offset, :first_header)
    attr_reader(:xing_header_offset, :xing_header)
    attr_reader(:vbri_header_offset, :vbri_header)
    attr_reader(:mpeg_version, :layer, :bitrate, :samplerate, :mode)
    attr_reader(:num_frames, :total_samples, :length)

    attr_accessor(:id3v1_tag, :id3v2_tag)

    def initialize(file_path)
      file_path = Pathname.new(file_path).expand_path if file_path.is_a?(String)
      load_file(file_path)
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

    private

    def value_from_tags(v1_field)
      if @id3v1_tag
        @id3v1_tag.send(v1_field)
      else
        nil
      end
    end

    def load_file(file_path)
      @file = file_path.open('rb')
      @file.seek(0, IO::SEEK_END)
      @file_size = @file.tell

      # Try to read an ID3v1 tag.
      @id3v1_tag = nil
      @file.seek(-128, IO::SEEK_END)
      @id3v1_tag = ID3v1Tag.parse(@file)
      @file.seek(0, IO::SEEK_SET)

      # Try to detect an ID3v2 header.
      @id3v2_tag = nil
      begin
        @id3v2_tag = ID3v2::Tag.new(@file)
      # rescue ID3v2::InvalidID3v2TagError => e
      #   $stderr.puts "Error parsing ID3v2 tag: %s\n\t%s" %
      #     [ e.message, e.backtrace.join("\n\t") ]
      #   @id3v2_tag = nil
      #   @file.seek(0, IO::SEEK_SET)
      end

      # Skip past the ID3v2 header if it's present.
      if @id3v2_tag
        @file.seek(@id3v2_tag.size, IO::SEEK_SET)
      end

      # Try to find the first MP3 header.
      @first_header_offset, @first_header = get_next_header(@file)

      @mpeg_version = @first_header.version
      @layer = @first_header.layer
      @bitrate = @first_header.bitrate / 1000
      @samplerate = @first_header.samplerate
      @mode = @first_header.mode
      @audio_size = @file_size
      if @id3v1_tag
        @audio_size -= 128
      end
      if @id3v2_header
        @audio_size -= (@id3v2_header.tag_size + 10)
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

      if @xing_header
        @vbr = true
        # Do the VBR length calculation.  What to do if we don't have
        # both of these pieces of information?
        if @xing_header.frames && @xing_header.bytes
          @num_frames = @xing_header.frames
          @total_samples = @xing_header.frames * @first_header.samples
          @length = total_samples / @samplerate
          @bitrate = ((@xing_header.bytes.to_f / @length.to_f) * 8 / 1000).to_i
        end
      else
        # Do the CBR length calculation.
        @vbr = false
        @num_frames = @audio_size / @first_header.frame_size
        @total_samples = @num_frames * @first_header.samples
        @length = @total_samples / @samplerate
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

      [ header_offset, header ]
    end
  end
end
