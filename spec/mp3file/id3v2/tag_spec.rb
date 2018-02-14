require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::Tag do
  describe "An empty tag" do
    subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x00\x00\x00\x00\x00")) }

    describe '#version' do
      subject { super().version }
      it { is_expected.to eq(Mp3file::ID3v2::ID3V2_3_0) }
    end

    describe '#unsynchronized' do
      subject { super().unsynchronized }
      it { is_expected.to eq(false) }
    end

    describe '#extended_header' do
      subject { super().extended_header }
      it { is_expected.to eq(false) }
    end

    describe '#compression' do
      subject { super().compression }
      it { is_expected.to eq(false) }
    end

    describe '#experimental' do
      subject { super().experimental }
      it { is_expected.to eq(false) }
    end

    describe '#footer' do
      subject { super().footer }
      it { is_expected.to eq(false) }
    end

    describe '#size' do
      subject { super().size }
      it { is_expected.to eq(10) }
    end

    describe '#frames' do
      subject { super().frames }
      it { is_expected.to eq([]) }
    end
  end
end
