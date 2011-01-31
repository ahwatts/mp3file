require 'forwardable'

module Mp3file::ID3v2
  class Tag
    extend Forwardable

    def_delegators(:@header, :version, :unsynchronized, :extended_header, 
      :compression, :experimental, :footer)

    attr_reader(:header, :frames)

    def initialize(io)
      @header = Header.new(io)
      @frames = []
    end

    def load_frames
      @frames = []
    end

    def size
      @header.tag_size + 10
    end
  end
end
