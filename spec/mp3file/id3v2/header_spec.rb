require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::Header do
  it "raises an error if the first 3 bytes don't say \"ID3\"" do
    io = StringIO.new("ID2\x03\x00\x00\x00\x00\x00\x00")
    expect { Mp3file::ID3v2::Header.new(io) }.to(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end

  it "raises an error if the major version is more than 4 (e.g., no ID3v2.5.0+)" do
    io = StringIO.new("ID3\x05\x00\x00\x00\x00\x00\x00")
    expect { Mp3file::ID3v2::Header.new(io) }.to(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end

  it "raises an error if the major version is less than 2 (e.g., no ID3v2.1.0)" do
    io = StringIO.new("ID3\x01\x00\x00\x00\x00\x00\x00")
    expect { Mp3file::ID3v2::Header.new(io) }.to(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end

  describe "flags:" do
    describe "An ID3v2.2 header with no set flags:" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00")) }

      describe '#version' do
        subject { super().version }
        it { is_expected.to eq(Mp3file::ID3v2::ID3V2_2_0) }
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
    end

    describe "An ID3v2.2 header with the unsync flag set:" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x02\x00\x80\x00\x00\x00\x00")) }

      describe '#version' do
        subject { super().version }
        it { is_expected.to eq(Mp3file::ID3v2::ID3V2_2_0) }
      end

      describe '#unsynchronized' do
        subject { super().unsynchronized }
        it { is_expected.to eq(true) }
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
    end

    describe "An ID3v2.2 header with the compression flag set:" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x02\x00\x40\x00\x00\x00\x00")) }

      describe '#version' do
        subject { super().version }
        it { is_expected.to eq(Mp3file::ID3v2::ID3V2_2_0) }
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
        it { is_expected.to eq(true) }
      end

      describe '#experimental' do
        subject { super().experimental }
        it { is_expected.to eq(false) }
      end

      describe '#footer' do
        subject { super().footer }
        it { is_expected.to eq(false) }
      end
    end

    describe "An ID3v2.2 header with an invalid flag set" do
      it "raises an error" do
        expect { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x02\x00\x20\x00\x00\x00\x00")) }.
          to(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
      end
    end

    describe "An ID3v2.3 header with the extended header flag set:" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x03\x00\x40\x00\x00\x00\x00")) }

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
        it { is_expected.to eq(true) }
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
    end

    describe "An ID3v2.3 header with the experimental header flag set:" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x03\x00\x20\x00\x00\x00\x00")) }

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
        it { is_expected.to eq(true) }
      end

      describe '#footer' do
        subject { super().footer }
        it { is_expected.to eq(false) }
      end
    end

    describe "An ID3v2.3 header with the experimental header flag set:" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x03\x00\x20\x00\x00\x00\x00")) }

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
        it { is_expected.to eq(true) }
      end

      describe '#footer' do
        subject { super().footer }
        it { is_expected.to eq(false) }
      end
    end

    describe "An ID3v2.3 header with an invalid flag set" do
      it "raises an error" do
        expect { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x03\x00\x10\x00\x00\x00\x00")) }.
          to(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
      end
    end

    describe "An ID3v2.4 header with the footer header flag set:" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x04\x00\x10\x00\x00\x00\x00")) }

      describe '#version' do
        subject { super().version }
        it { is_expected.to eq(Mp3file::ID3v2::ID3V2_4_0) }
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
        it { is_expected.to eq(true) }
      end
    end
  end

  describe "#version" do
    it "detects ID3v2.2.0" do
      t = Mp3file::ID3v2::Header.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00"))
      expect(t.version).to eq(Mp3file::ID3v2::ID3V2_2_0)
    end

    it "detects ID3v2.3.0" do
      t = Mp3file::ID3v2::Header.new(StringIO.new("ID3\x03\x00\x00\x00\x00\x00\x00"))
      expect(t.version).to eq(Mp3file::ID3v2::ID3V2_3_0)
    end

    it "detects ID3v2.4.0" do
      t = Mp3file::ID3v2::Header.new(StringIO.new("ID3\x04\x00\x00\x00\x00\x00\x00"))
      expect(t.version).to eq(Mp3file::ID3v2::ID3V2_4_0)
    end
  end

  describe "#size" do
    it "properly reads the size of an ID3v2 tag" do
      t = Mp3file::ID3v2::Header.new(StringIO.new("ID3\x03\x00\x00\x00\x06\x49\x37"))
      expect(t.tag_size).to eq(107703)
    end
  end

  describe "flags for ID3v2.2" do
    describe "An ID3v2.2 header with no set flags" do
      subject { Mp3file::ID3v2::Header.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00")) }
    end
  end
end
