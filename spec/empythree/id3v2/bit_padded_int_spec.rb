require File.dirname(__FILE__) + '/../../../lib/empythree'

describe Empythree::ID3v2::BitPaddedInt do
  describe ".unpad_number" do
    it "returns 0 when unpadding 0" do
      expect(Empythree::ID3v2::BitPaddedInt.unpad_number(0)).to eq(0)
    end

    context "without specifying bits" do
      it "returns the least significant 7 bits of each byte in a 4-byte number" do
        expect(Empythree::ID3v2::BitPaddedInt.unpad_number(0xFF_FF_FF_FF)).to eq(0x0F_FF_FF_FF)

        expect(Empythree::ID3v2::BitPaddedInt.unpad_number(0b0101_0101_0101_0101_0101_0101_0101_0101))
          .to                                           eq(0b0000_1010_1011_0101_0110_1010_1101_0101)

        expect(Empythree::ID3v2::BitPaddedInt.unpad_number(0b1010_1010_1010_1010_1010_1010_1010_1010))
          .to                                           eq(0b0000_0101_0100_1010_1001_0101_0010_1010)
      end
    end

    context "specifying bits as n" do
      it "returns the least significant n bits from each byte of a 4-byte number" do
        1.upto(7) do |n|
          expect(Empythree::ID3v2::BitPaddedInt.unpad_number(0xFF_FF_FF_FF, n)).to eq(16**n - 1)
        end

        expect(Empythree::ID3v2::BitPaddedInt.unpad_number(0b0101_0101_0101_0101_0101_0101_0101_0101, 5))
          .to                                                          eq(0b1010_1101_0110_1011_0101)

        expect(Empythree::ID3v2::BitPaddedInt.unpad_number(0b1010_1010_1010_1010_1010_1010_1010_1010, 3))
          .to                                                                     eq(0b1001_001_0010)
      end
    end
  end

  describe ".pad_number" do
    it "returns 0 when padding 0" do
      expect(Empythree::ID3v2::BitPaddedInt.pad_number(0)).to eq(0)
    end

    context "without specifying bits" do
      it "keeps the least significant 28 bits of a 4-byte number and pads each byte with a 0" do
        expect(Empythree::ID3v2::BitPaddedInt.pad_number(0xFF_FF_FF_FF))
          .to                                         eq(0x7F_7F_7F_7F)

        expect(Empythree::ID3v2::BitPaddedInt.pad_number(0b0101_0101_0101_0101_0101_0101_0101_0101))
          .to                                         eq(0b0010_1010_0101_0101_0010_1010_0101_0101)

        expect(Empythree::ID3v2::BitPaddedInt.pad_number(0b1010_1010_1010_1010_1010_1010_1010_1010))
          .to                                         eq(0b0101_0101_0010_1010_0101_0101_0010_1010)
      end
    end

    context "specifying bits as n" do
      it "keeps the bottom n*4 bits and pads each byte with 0s" do
        1.upto(7) do |n|
          expect(Empythree::ID3v2::BitPaddedInt.pad_number(0xFF_FF_FF_FF, n))
            .to eq((2**n - 1)*(256**3 + 256**2 + 256**1 + 1))
        end
      end
    end
  end
end
