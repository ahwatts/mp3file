require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::Version do
  describe Mp3file::ID3v2::ID3V2_2_0 do
    subject { Mp3file::ID3v2::ID3V2_2_0 }

    describe '#vbig' do
      subject { super().vbig }
      it { is_expected.to eq(2) }
    end

    describe '#vmaj' do
      subject { super().vmaj }
      it { is_expected.to eq(2) }
    end

    describe '#vmin' do
      subject { super().vmin }
      it { is_expected.to eq(0) }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { is_expected.to eq('ID3v2.2.0') }
    end

    describe '#to_byte_string' do
      subject { super().to_byte_string }
      it { is_expected.to eq("\x02\x00") }
    end
  end

  describe Mp3file::ID3v2::ID3V2_3_0 do
    subject { Mp3file::ID3v2::ID3V2_3_0 }

    describe '#vbig' do
      subject { super().vbig }
      it { is_expected.to eq(2) }
    end

    describe '#vmaj' do
      subject { super().vmaj }
      it { is_expected.to eq(3) }
    end

    describe '#vmin' do
      subject { super().vmin }
      it { is_expected.to eq(0) }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { is_expected.to eq('ID3v2.3.0') }
    end

    describe '#to_byte_string' do
      subject { super().to_byte_string }
      it { is_expected.to eq("\x03\x00") }
    end
  end

  describe Mp3file::ID3v2::ID3V2_4_0 do
    subject { Mp3file::ID3v2::ID3V2_4_0 }

    describe '#vbig' do
      subject { super().vbig }
      it { is_expected.to eq(2) }
    end

    describe '#vmaj' do
      subject { super().vmaj }
      it { is_expected.to eq(4) }
    end

    describe '#vmin' do
      subject { super().vmin }
      it { is_expected.to eq(0) }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { is_expected.to eq('ID3v2.4.0') }
    end

    describe '#to_byte_string' do
      subject { super().to_byte_string }
      it { is_expected.to eq("\x04\x00") }
    end
  end

  describe "#<=>" do
    it("should recognize that ID3v2.2 < ID3v2.3") do
      expect(Mp3file::ID3v2::ID3V2_2_0 <=> Mp3file::ID3v2::ID3V2_3_0).to eq(-1)
    end

    it("should recognize that ID3v2.4 > ID3v2.2") do
      expect(Mp3file::ID3v2::ID3V2_4_0 <=> Mp3file::ID3v2::ID3V2_2_0).to eq(1)
    end

    it("should recognize that ID3v2.3 == ID3v2.3") do
      expect(Mp3file::ID3v2::ID3V2_3_0 <=> Mp3file::ID3v2::ID3V2_3_0).to eq(0)
    end
  end

  describe "#new" do
    subject { Mp3file::ID3v2::Version.new(3, 1) }

    describe '#vbig' do
      subject { super().vbig }
      it { is_expected.to eq(2) }
    end

    describe '#vmaj' do
      subject { super().vmaj }
      it { is_expected.to eq(3) }
    end

    describe '#vmin' do
      subject { super().vmin }
      it { is_expected.to eq(1) }
    end

    describe '#to_s' do
      subject { super().to_s }
      it { is_expected.to eq('ID3v2.3.1') }
    end

    describe '#to_byte_string' do
      subject { super().to_byte_string }
      it { is_expected.to eq("\x03\x01") }
    end
  end
end
