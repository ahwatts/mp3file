require File.dirname(__FILE__) + '/../lib/mp3file/bit_padded_int'

describe Mp3file::BitPaddedInt, ".unpad_number" do
  it "returns 0 when unpadding 0" do
    Mp3file::BitPaddedInt.unpad_number(0).should == 0
  end

  context "without specifying bits" do
    it "returns the bottom 7 bits of each byte in a 4-byte number" do
      Mp3file::BitPaddedInt.unpad_number(0xFF_FF_FF_FF).
        should == 0x0F_FF_FF_FF
      Mp3file::BitPaddedInt.unpad_number(0b0101_0101_0101_0101_0101_0101_0101_0101).
        should == 0b0000_1010_1011_0101_0110_1010_1101_0101
      Mp3file::BitPaddedInt.unpad_number(0b1010_1010_1010_1010_1010_1010_1010_1010).
        should == 0b0000_0101_0100_1010_1001_0101_0010_1010
    end
  end

  context "specifying bits as n" do
    it "returns the bottom n bits of a 4-byte number" do
      1.upto(7) do |n|
        Mp3file::BitPaddedInt.unpad_number(0xFF_FF_FF_FF, n).
          should == 16**n - 1
      end
      Mp3file::BitPaddedInt.unpad_number(0b0101_0101_0101_0101_0101_0101_0101_0101, 5).
        should == 0b1010_1101_0110_1011_0101
      Mp3file::BitPaddedInt.unpad_number(0b1010_1010_1010_1010_1010_1010_1010_1010, 3).
        should == 0b1001_001_0010
    end
  end
end

describe Mp3file::BitPaddedInt, ".pad_number" do
  it "returns 0 when padding 0" do
    Mp3file::BitPaddedInt.pad_number(0).should == 0
  end

  context "without specifying bits" do
    it "keeps the bottom 28 bits and pads each byte with a 0" do
      Mp3file::BitPaddedInt.pad_number(0xFF_FF_FF_FF).
        should == 0x7F_7F_7F_7F
      Mp3file::BitPaddedInt.pad_number(0b0101_0101_0101_0101_0101_0101_0101_0101).
        should == 0b0010_1010_0101_0101_0010_1010_0101_0101
      Mp3file::BitPaddedInt.pad_number(0b1010_1010_1010_1010_1010_1010_1010_1010).
        should == 0b0101_0101_0010_1010_0101_0101_0010_1010
    end
  end

  context "specifying bits as n" do
    it "keeps the bottom n*4 bits and pads each byte with 0s" do
      1.upto(7) do |n|
        Mp3file::BitPaddedInt.pad_number(0xFF_FF_FF_FF, n).
          should == (2**n - 1)*(256**3 + 256**2 + 256**1 + 1)
      end
    end
  end
end
