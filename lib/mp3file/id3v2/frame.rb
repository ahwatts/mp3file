module Mp3file::ID3v2
  class FrameHeader
    class ID3v220FrameHeaderFormat < BinData::Record
      string(:frame_id, :length => 3)
    end

    class ID3v230FrameHeaderFormat < BinData::Record
    end

    class ID3v240FrameHeaderFormat < BinData::Record
    end

    attr_reader(:frame_id, :size, :flags)
  end
end
