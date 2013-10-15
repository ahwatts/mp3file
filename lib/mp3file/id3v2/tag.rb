require 'forwardable'

module Mp3file::ID3v2
  class Tag
    extend Forwardable

    def_delegators(:@header, :version, :unsynchronized, :extended_header, 
      :compression, :experimental, :footer)

    attr_reader(:header, :frames, :unused_bytes)

    FRAME_HEADER_NAME_REGEX = /[A-Z][A-Z0-9]{2,3}/

    def initialize(io)
      @header = Header.new(io)
      load_frames(io)
      used_bytes = @frames.inject(0) { |m, f| m += f.size }
      @unused_bytes = @header.tag_size - used_bytes
    end

    def load_frames(io)
      @frames = []

      data = io.read(@header.tag_size)
      data.force_encoding("ASCII-8BIT")
      offset = 0

      frame_offset, frame = get_next_frame_header(data, offset)
      while frame
        @frames << frame
        offset = frame_offset + frame.size
        frame_offset, frame = get_next_frame_header(data, offset)
      end
    end

    def size
      @header.tag_size + 10
    end

    def get_next_frame_header(data, offset)
      md = data.match(FRAME_HEADER_NAME_REGEX, offset)

      while md
        frame_offset = md.begin(0)
        io = StringIO.new(data[frame_offset, 32])
        frame = FrameHeader.new(io, self)

        if frame.frame_id.to_s =~ FRAME_HEADER_NAME_REGEX
          return [ frame_offset, frame ]
        else
          frame_offset = md.end(0) + 1
          md = data.match(FRAME_HEADER_NAME_REGEX, frame_offset)
        end
      end

      [ nil, nil ]
    end
  end
end
