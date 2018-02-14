require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::XingHeader do
  it 'raises an error if the first 4 bytes don\'t say "Xing"' do
    io = StringIO.new("Ping\x00\x00\x00\x00")
    expect { Mp3file::XingHeader.new(io) }.to(raise_error(Mp3file::InvalidXingHeaderError))
  end

  it 'raises an error if the next int is more than 15' do
    io = StringIO.new("Xing\x00\x00\x00\x10")
    expect { Mp3file::XingHeader.new(io) }.to(raise_error(Mp3file::InvalidXingHeaderError))
  end

  describe "with no parts" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x00")) }

    describe '#frames' do
      subject { super().frames }
      it { is_expected.to eq(nil) }
    end

    describe '#bytes' do
      subject { super().bytes }
      it { is_expected.to eq(nil) }
    end

    describe '#toc' do
      subject { super().toc }
      it { is_expected.to eq(nil) }
    end

    describe '#quality' do
      subject { super().quality }
      it { is_expected.to eq(nil) }
    end
  end

  describe "with only a frame count" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x01\x00\x00\x14\xFA")) }

    describe '#frames' do
      subject { super().frames }
      it { is_expected.to eq(5370) }
    end

    describe '#bytes' do
      subject { super().bytes }
      it { is_expected.to eq(nil) }
    end

    describe '#toc' do
      subject { super().toc }
      it { is_expected.to eq(nil) }
    end

    describe '#quality' do
      subject { super().quality }
      it { is_expected.to eq(nil) }
    end
  end

  describe "with only a byte count" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x02\x00\x00\x14\xFA")) }

    describe '#frames' do
      subject { super().frames }
      it { is_expected.to eq(nil) }
    end

    describe '#bytes' do
      subject { super().bytes }
      it { is_expected.to eq(5370) }
    end

    describe '#toc' do
      subject { super().toc }
      it { is_expected.to eq(nil) }
    end

    describe '#quality' do
      subject { super().quality }
      it { is_expected.to eq(nil) }
    end
  end

  describe "with only a TOC" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x04" + ("\x00" * 100))) }

    describe '#frames' do
      subject { super().frames }
      it { is_expected.to eq(nil) }
    end

    describe '#bytes' do
      subject { super().bytes }
      it { is_expected.to eq(nil) }
    end

    describe '#toc' do
      subject { super().toc }
      it { is_expected.to eq([ 0 ] * 100) }
    end

    describe '#quality' do
      subject { super().quality }
      it { is_expected.to eq(nil) }
    end
  end

  describe "with only a quality" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x08\x00\x00\x00\x55")) }

    describe '#frames' do
      subject { super().frames }
      it { is_expected.to eq(nil) }
    end

    describe '#bytes' do
      subject { super().bytes }
      it { is_expected.to eq(nil) }
    end

    describe '#toc' do
      subject { super().toc }
      it { is_expected.to eq(nil) }
    end

    describe '#quality' do
      subject { super().quality }
      it { is_expected.to eq(85) }
    end
  end

  describe "with all four" do
    subject do
      str = [ 
        'Xing', # ID
        "\x00\x00\x00\x0F", # Which fields are present
        "\x00\x4B\xF4\x80", # The frame count
        "\x00\x1C\x7B\xB0", # The byte count
        "\x00" * 100,       # The TOC
        "\x00\x00\x00\x55",  # The quality
      ].join('')
      Mp3file::XingHeader.new(StringIO.new(str))
    end

    describe '#frames' do
      subject { super().frames }
      it { is_expected.to eq(4977792) }
    end

    describe '#bytes' do
      subject { super().bytes }
      it { is_expected.to eq(1866672) }
    end

    describe '#toc' do
      subject { super().toc }
      it { is_expected.to eq([ 0 ] * 100) }
    end

    describe '#quality' do
      subject { super().quality }
      it { is_expected.to eq(85) }
    end
  end
end
