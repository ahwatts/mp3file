require 'forwardable'

module Mp3file::ID3v2
  class Tag
    extend Forwardable

    def_delegators(:@header, :version, :unsynchronized, :extended_header, 
      :compression, :experimental, :footer)

    attr_reader(:header, :frames, :unused_bytes)

    def initialize(io)
      @header = Header.new(io)
      @unused_bytes = 0
      load_frames(io)
    end

    def load_frames(io)
      @frames = []
      frame_offset, frame = get_next_frame_header(io)
      while frame
        @frames << frame
        frame_offset, frame = get_next_frame_header(io)
      end
    end

    def size
      @header.tag_size + 10
    end

    def get_next_frame_header(io, offset = nil)
      if offset && offset != io.tell
        file.seek(offset, IO::SEEK_SET)
      end

      frame = nil
      frame_offset = nil

      while frame.nil? && io.tell < size
        frame_offset = io.tell
        frame = FrameHeader.new(io, self)
        io.seek(io.tell + frame.size, IO::SEEK_SET)
        if frame.frame_id.to_s =~ /[A-Z0-9]{3,4}/
          @unused_bytes = 0
          return [ frame_offset, frame ]
        else
          frame = nil
          @unused_bytes += (io.tell - frame_offset)
        end
      end

      [ nil, nil ]
    end
  end
end
