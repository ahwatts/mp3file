module Empythree
  class InvalidXingHeaderError < MP3FileError; end

  class XingHeader
    attr_reader(:frames, :bytes, :toc, :quality)

    class XingHeaderFormat < BinData::Record
      string(:vbr_id, :length => 4, :check_value => lambda { value == 'Xing' })

      uint8(:unused1, :check_value => lambda { value == 0 })
      uint8(:unused2, :check_value => lambda { value == 0 })
      uint8(:unused3, :check_value => lambda { value == 0 })
      bit4(:unused4, :check_value => lambda { value == 0 })
      bit1(:quality_present)
      bit1(:toc_present)
      bit1(:bytes_present)
      bit1(:frames_present)

      uint32be(:frames, :onlyif => lambda { frames_present == 1 })
      uint32be(:bytes, :onlyif => lambda { bytes_present == 1 })
      array(:toc, :type => :uint8, :read_until => lambda { index == 99 }, :onlyif => lambda { toc_present == 1 })
      uint32be(:quality, :onlyif => lambda { quality_present == 1 })
    end

    def initialize(io)
      head = nil
      begin
        head = XingHeaderFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidXingHeaderError, ve.message
      end

      @frames = head.frames if head.frames_present == 1
      @bytes = head.bytes if head.bytes_present == 1
      @toc = head.toc.dup if head.toc_present == 1
      @quality = head.quality if head.quality_present == 1
    end
  end
end
