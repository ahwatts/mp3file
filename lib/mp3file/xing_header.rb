module Mp3file
  class InvalidXingHeaderError < Mp3fileError; end

  class XingHeader
    attr_reader(:name, :frames, :bytes, :toc, :quality)

    class XingHeaderFormat < BinData::Record
      string(:vbr_id, read_length: 4, assert: -> { value == 'Xing' || value == 'Info' })

      uint8(:unused1, asserted_value: 0)
      uint8(:unused2, asserted_value: 0)
      uint8(:unused3, asserted_value: 0)
      bit4(:unused4, asserted_value: 0)
      bit1(:quality_present)
      bit1(:toc_present)
      bit1(:bytes_present)
      bit1(:frames_present)

      uint32be(:frames, onlyif: -> { frames_present == 1 })
      uint32be(:bytes, onlyif: -> { bytes_present == 1 })
      array(:toc, type: :uint8, read_until: -> { index == 99 }, onlyif: -> { toc_present == 1 })
      uint32be(:quality, onlyif: -> { quality_present == 1 })
    end

    def initialize(io)
      head = nil
      begin
        head = XingHeaderFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidXingHeaderError, ve.message
      end

      @name = head.vbr_id
      @frames = head.frames if (head.frames_present == 1 && head.frames > 0)
      @bytes = head.bytes if (head.bytes_present == 1 && head.bytes > 0)
      @toc = head.toc.dup if (head.toc_present == 1 && !head.toc.empty?)
      @quality = head.quality if (head.quality_present == 1 && head.quality > 0)
    end
  end
end
