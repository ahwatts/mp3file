module Mp3file::ID3v2
  class Header
    attr_reader(
      :version, 
      :unsynchronized, 
      :extended_header, 
      :compression,
      :experimental, 
      :footer, 
      :tag_size)

    class ID3v2HeaderFormat < BinData::Record
      string(:tag_id, read_length: 3, asserted_value: "ID3")
      uint8(:vmaj, assert: -> { (2..4) === value })
      uint8(:vmin)

      bit1(:unsynchronized)
      bit1(:extended_header)
      bit1(:experimental)
      bit1(:footer)
      bit4(:unused)

      uint32be(:size_padded)
    end

    def initialize(io)
      header = nil
      begin
        header = ID3v2HeaderFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidID3v2TagError, ve.message
      end

      @version = Version.new(header.vmaj, header.vmin)

      @unsynchronized = false
      @extended_header = false
      @compression = false
      @experimental = false
      @footer = false

      if @version >= ID3V2_2_0 && @version < ID3V2_3_0
        @unsynchronized = header.unsynchronized == 1
        # Bit 6 was redefined in v2.3.0+, and we picked the new name
        # for it above.
        @compression = header.extended_header == 1
        if header.experimental == 1 || header.footer == 1
          raise InvalidID3v2TagError, "Invalid flag set in ID3v2.2 header"
        end
      elsif @version >= ID3V2_3_0 && @version < ID3V2_4_0
        @unsynchronized = header.unsynchronized == 1
        @extended_header = header.extended_header == 1
        @experimental = header.experimental == 1
        if header.footer == 1
          raise InvalidID3v2TagError, "Invalid flag set in ID3v2.3 header"
        end
      elsif @version >= ID3V2_4_0 
        @unsynchronized = header.unsynchronized == 1
        @extended_header = header.extended_header == 1
        @experimental = header.experimental == 1
        @footer = header.footer == 1
      end

      @tag_size = BitPaddedInt.unpad_number(header.size_padded)
    end
  end
end
