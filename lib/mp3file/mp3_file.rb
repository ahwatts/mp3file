module Mp3file
  class MP3File
    attr_reader(:file, :file_size, :audio_size)
    attr_reader(:first_header_offset, :first_header)
    attr_reader(:xing_header_offset, :xing_header)
    attr_reader(:vbri_header_offset, :vbri_header)
    attr_reader(:mpeg_version, :layer, :bitrate, :samplerate, :mode)
    attr_reader(:num_frames, :total_samples, :length)

    def initialize(file_path)
      file_path = Pathname.new(file_path).expand_path if file_path.is_a?(String)
      load_file(file_path)
    end

    def vbr?
      @vbr
    end

    def id3v1tag?
      @has_id3v1tag
    end

    def id3v2tag?
      @has_id3v2tag
    end

    private

    def load_file(file_path)
      @file = file_path.open('rb')
      @file.seek(0, IO::SEEK_END)
      @file_size = @file.tell
      @file.seek(0, IO::SEEK_SET)

      # Try to parse an ID3 header.
      @id3v2tag = nil
      idata = @file.read(10).unpack("a3CCB8N")
      id3_indicator = idata[0]
      id3_size = BitPaddedInt.unpad_number(idata[4])

      if id3_indicator == "ID3" && id3_size > 0
        # @id3v2tag = ID3v2::Tag.new(@file)
        # @file.seek(@id3v2tag.size, IO::SEEK_SET)
        @has_id3v2tag = true
        @file.seek(id3_size, IO::SEEK_SET)
      else
        @has_id3v2tag = false
        @file.seek(0, IO::SEEK_SET)
      end

      # Try to find the first MP3 header.
      @first_header_offset, @first_header = get_next_header(@file)

      @mpeg_version = @first_header.version
      @layer = @first_header.layer
      @bitrate = @first_header.bitrate / 1000
      @samplerate = @first_header.samplerate
      @mode = @first_header.mode
      @audio_size = @file_size
      if @id3v2tag
        @audio_size -= @id3v2tag.size
      end

      # If it's VBR, there should be an Xing header after the
      # side_bytes.
      @xing_header = nil
      @file.seek(@first_header.side_bytes, IO::SEEK_CUR)
      begin
        @xing_header = XingHeader.new(@file)
      rescue InvalidXingHeaderError => ve
        @file.seek(@first_header_offset + 4, IO::SEEK_CUR)
      end

      # # There might be a VBRI header after 32 bytes
      # if @xing_header.nil?
      #   @file.seek(@first_header_offset + 36, IO::SEEK_SET)
      #   xdata = @file.read(26).unpack("a4a*")
      #   if xdata[0] == "VBRI"
      #     raise NotImplementedError, "VBRI tags have not been implemented."
      #   end
      # end

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
        # Do the CBR length calculation.  Note that this will be
        # off by about a second in the presence of an ID3v1 tag.
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
      header_offset = file.tell

      while header.nil?
        begin
          header = MP3Header.new(file)
          header_offset = file.tell - 4
        rescue InvalidMP3HeaderError => e
          header_offset += 1
          file.seek(header_offset, IO::SEEK_SET)
          retry
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
