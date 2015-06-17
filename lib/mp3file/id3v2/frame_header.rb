module Mp3file::ID3v2
  class FrameHeader
    class ID3v220FrameHeaderFormat < BinData::Record
      string(:frame_id, :length => 3)
      uint24be(:frame_size)
    end

    class ID3v230FrameHeaderFormat < BinData::Record
      string(:frame_id, :length => 4)
      uint32be(:frame_size)
      bit1(:tag_alter_preserve)
      bit1(:file_alter_preserve)
      bit1(:read_only)
      bit5(:unused1) # , :check_value => lambda { value == 0 })
      bit1(:compression)
      bit1(:encryption)
      bit1(:has_group)
      bit5(:unused2) # , :check_value => lambda { value == 0 })
      uint8(:encryption_type, :onlyif => lambda { encryption == 1 })
      uint8(:group_id, :onlyif => lambda { has_group == 1 })
    end

    class ID3v240FrameHeaderFormat < BinData::Record
      string(:frame_id, :length => 4)
      uint32be(:frame_size)
      bit1(:unused1) # , :check_value => lambda { value == 0 })
      bit1(:tag_alter_preserve)
      bit1(:file_alter_preserve)
      bit1(:read_only)

      bit4(:unused2) # , :check_value => lambda { value == 0 })

      bit1(:unused3) # , :check_value => lambda { value == 0 })
      bit1(:group)
      bit2(:unused4) # , :check_value => lambda { value == 0 })

      bit1(:compression)
      bit1(:encryption)
      bit1(:unsynchronized)
      bit1(:data_length_indicator)
    end

    attr_reader(:frame_id, :header_size, :frame_size, :size,
      :preserve_on_altered_tag, :preserve_on_altered_file,
      :read_only, :compressed, :encrypted, :encryption_type,
      :group, :unsynchronized, :data_length)

    def initialize(io, tag)
      @tag = tag
      header = nil
      @preserve_on_altered_tag = false
      @preserve_on_altered_file = false
      @read_only = false
      @compressed = false
      @encrypted = false
      @group = nil
      @unsynchronized = false
      @data_length = 0

      begin
        if @tag.version >= ID3V2_2_0 && @tag.version < ID3V2_3_0
          header = ID3v220FrameHeaderFormat.read(io)
          @header_size = 6
          @frame_size = header.frame_size
        elsif @tag.version >= ID3V2_3_0 && @tag.version < ID3V2_4_0
          header = ID3v230FrameHeaderFormat.read(io)
          @header_size = 10
          @preserve_on_altered_tag = header.tag_alter_preserve == 1
          @preserve_on_altered_file = header.file_alter_preserve == 1
          @read_only = header.read_only == 1
          @compressed = header.compression == 1
          if header.encryption == 1
            @encrypted = true
            @encryption_type = header.encryption_type
          end
          if header.has_group == 1
            @group = header.group_id
          end
          @frame_size = header.frame_size
        elsif @tag.version >= ID3V2_4_0
          header = ID3v240FrameHeaderFormat.read(io)
          @header_size = 10
          @frame_size = BitPaddedInt.unpad_number(header.frame_size)
        end
      rescue BinData::ValidityError => ve
        raise InvalidID3v2TagError, ve.message
      end

      @frame_id = header.frame_id
      @size = @header_size + @frame_size
    end
  end
end
