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
      bit5(:unused1, :check_value => lambda { value == 0 })
      bit1(:compression)
      bit1(:encryption)
      bit1(:group)
      bit5(:unused2, :check_value => lambda { value == 0 })
    end

    class ID3v240FrameHeaderFormat < BinData::Record
      string(:frame_id, :length => 4)
      uint32be(:frame_size)
      bit1(:unused1, :check_value => lambda { value == 0 })
      bit1(:tag_alter_preserve)
      bit1(:file_alter_preserve)
      bit1(:read_only)
      bit4(:unused2, :check_value => lambda { value == 0 })
      bit1(:unused3, :check_value => lambda { value == 0 })
      bit1(:group)
      bit2(:unused4, :check_value => lambda { value == 0 })
      bit1(:compression)
      bit1(:encryption)
      bit1(:unsynchronized)
      bit1(:data_length_indicator)
    end

    attr_reader(:frame_id, :size,
      :preserve_on_altered_tag, :preserve_on_altered_file,
      :read_only, :compressed, :encrypted, :group,
      :unsynchronized, :data_length)

    def initialize(io, tag)
      @tag = tag

      if @tag.version >= ID3V2_2_0 && @tag.version < ID3V2_3_0
        header = ID3v220FrameHeaderFormat.read(io)
      elsif @tag.version >= ID3V2_3_0 && @tag.version < ID3V2_4_0
        header = ID3v230FrameHeaderFormat.read(io)
      elsif @tag.version >= ID3v2_4_0
        header = ID3v240FrameHeaderFormat.read(i0)
      end
    end
  end
end
