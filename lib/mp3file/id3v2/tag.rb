module Mp3file::ID3v2
  class Tag
    attr_reader(
      :version, 
      :unsynchronized, 
      :extended_header, 
      :compression,
      :experimental, 
      :footer, 
      :size)

    class ID3v2TagFormat < BinData::Record
      string(:tag_id, :length => 3, :check_value => lambda { value == 'ID3' })
      uint8(:vmaj, :check_value => lambda { value >= 2 && value <= 4 })
      uint8(:vmin)

      bit1(:unsynchronized)
      bit1(:extended_header)
      bit1(:experimental)
      bit1(:footer)
      bit4(:unused, :check_value => lambda { value == 0 })

      uint32be(:size_padded)
    end

    def initialize(io)
      tag = nil
      begin
        tag = ID3v2TagFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidID3v2TagError, ve.message
      end

      @version = Version.new(tag.vmaj, tag.vmin)

      @unsynchronized = false
      @extended_header = false
      @compression = false
      @experimental = false
      @footer = false

      if @version >= ID3V2_2_0 && @version < ID3V2_3_0
        @unsynchronized = tag.unsynchronized == 1
        # Bit 6 was redefined if v2.3.0+, and we picked the new name
        # for it above.
        @compression = tag.extended_header == 1
        if tag.experimental == 1 || tag.footer == 1
          raise InvalidID3v2TagError, "Invalid flag set in ID3v2.2 tag"
        end
      elsif @version >= ID3V2_3_0 && @version < ID3V2_4_0
        @unsynchronized = tag.unsynchronized == 1
        @extended_header = tag.extended_header == 1
        @experimental = tag.experimental == 1
        if tag.footer == 1
          raise InvalidID3v2TagError, "Invalid flag set in ID3v2.3 tag"
        end
      elsif @version >= ID3V2_4_0 
        @unsynchronized = tag.unsynchronized == 1
        @extended_header = tag.extended_header == 1
        @experimental = tag.experimental == 1
        @footer = tag.footer == 1
      end

      @size = BitPaddedInt.unpad_number(tag.size_padded) + 10
    end
  end
end
