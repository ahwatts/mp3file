module Mp3file::ID3v2
  class Tag
    attr_reader(:version, :unsynchronized, :extended_header, :experimental, 
      :footer, :size)

    class ID3v2TagFormat < BinData::Record
      string(:tag_id, :length => 3, :check_value => lambda { value == 'ID3' })
      uint8(:vmaj, :check_value => lambda { value <= 3 })
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
        head = ID3v2TagFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidID3v2TagError, ve.message
      end
    end
  end
end
