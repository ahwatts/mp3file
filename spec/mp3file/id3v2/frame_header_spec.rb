require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::FrameHeader do
  context "with ID3v2.2 tags" do
    let(:tag) { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00")) }

    describe("A 15-byte long TT2 frame header.") do
      subject { Mp3file::ID3v2::FrameHeader.new(StringIO.new("TT2\x00\x00\x0f"), tag) }

      describe '#frame_id' do
        subject { super().frame_id }
        it { is_expected.to eq('TT2') }
      end

      describe '#size' do
        subject { super().size }
        it { is_expected.to eq(21) }
      end

      describe '#frame_size' do
        subject { super().frame_size }
        it { is_expected.to eq(15) }
      end

      describe '#preserve_on_altered_tag' do
        subject { super().preserve_on_altered_tag }
        it { is_expected.to eq(false) }
      end

      describe '#preserve_on_altered_file' do
        subject { super().preserve_on_altered_file }
        it { is_expected.to eq(false) }
      end

      describe '#read_only' do
        subject { super().read_only }
        it { is_expected.to eq(false) }
      end

      describe '#compressed' do
        subject { super().compressed }
        it { is_expected.to eq(false) }
      end

      describe '#encrypted' do
        subject { super().encrypted }
        it { is_expected.to eq(false) }
      end

      describe '#encryption_type' do
        subject { super().encryption_type }
        it { is_expected.to be_nil }
      end

      describe '#group' do
        subject { super().group }
        it { is_expected.to be_nil }
      end

      describe '#unsynchronized' do
        subject { super().unsynchronized }
        it { is_expected.to eq(false) }
      end

      describe '#data_length' do
        subject { super().data_length }
        it { is_expected.to eq(0) }
      end
    end
  end
  
  context "with ID3v2.3 tags" do
    let(:tag) { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x00\x00\x00\x00\x00")) }

    # describe("A header with invalid flag bits set") do
    #   it("Should raise an error") do
    #     io = StringIO.new("TIT2\x00\x00\x00\x09\x01\x00")
    #     lambda { Mp3file::ID3v2::FrameHeader.new(io, tag) }.
    #       should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
    #   end
    # end
    
    describe("A 9-byte TIT2 frame header.") do
      subject { Mp3file::ID3v2::FrameHeader.new(StringIO.new("TIT2\x00\x00\x00\x09\x00\x00"), tag) }

      describe '#frame_id' do
        subject { super().frame_id }
        it { is_expected.to eq('TIT2') }
      end

      describe '#size' do
        subject { super().size }
        it { is_expected.to eq(19) }
      end

      describe '#frame_size' do
        subject { super().frame_size }
        it { is_expected.to eq(9) }
      end

      describe '#preserve_on_altered_tag' do
        subject { super().preserve_on_altered_tag }
        it { is_expected.to eq(false) }
      end

      describe '#preserve_on_altered_file' do
        subject { super().preserve_on_altered_file }
        it { is_expected.to eq(false) }
      end

      describe '#read_only' do
        subject { super().read_only }
        it { is_expected.to eq(false) }
      end

      describe '#compressed' do
        subject { super().compressed }
        it { is_expected.to eq(false) }
      end

      describe '#encrypted' do
        subject { super().encrypted }
        it { is_expected.to eq(false) }
      end

      describe '#encryption_type' do
        subject { super().encryption_type }
        it { is_expected.to be_nil }
      end

      describe '#group' do
        subject { super().group }
        it { is_expected.to be_nil }
      end

      describe '#unsynchronized' do
        subject { super().unsynchronized }
        it { is_expected.to eq(false) }
      end

      describe '#data_length' do
        subject { super().data_length }
        it { is_expected.to eq(0) }
      end
    end

    describe("A TIT2 header with all of its flags set") do
      subject { Mp3file::ID3v2::FrameHeader.new(StringIO.new("TIT2\x00\x00\x00\x09\x00\x00"), tag) }

      describe '#frame_id' do
        subject { super().frame_id }
        it { is_expected.to eq('TIT2') }
      end

      describe '#size' do
        subject { super().size }
        it { is_expected.to eq(19) }
      end

      describe '#frame_size' do
        subject { super().frame_size }
        it { is_expected.to eq(9) }
      end

      describe '#preserve_on_altered_tag' do
        subject { super().preserve_on_altered_tag }
        it { is_expected.to eq(false) }
      end

      describe '#preserve_on_altered_file' do
        subject { super().preserve_on_altered_file }
        it { is_expected.to eq(false) }
      end

      describe '#read_only' do
        subject { super().read_only }
        it { is_expected.to eq(false) }
      end

      describe '#compressed' do
        subject { super().compressed }
        it { is_expected.to eq(false) }
      end

      describe '#encrypted' do
        subject { super().encrypted }
        it { is_expected.to eq(false) }
      end

      describe '#encryption_type' do
        subject { super().encryption_type }
        it { is_expected.to be_nil }
      end

      describe '#group' do
        subject { super().group }
        it { is_expected.to be_nil }
      end

      describe '#unsynchronized' do
        subject { super().unsynchronized }
        it { is_expected.to eq(false) }
      end

      describe '#data_length' do
        subject { super().data_length }
        it { is_expected.to eq(0) }
      end
    end
  end

  context "with ID3v2.4 tags" do
    let(:tag) { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x04\x00\x00\x00\x00\x00\x00")) }

    # describe("A header with invalid flag bits set") do
    #   it("Should raise an error") do
    #     io = StringIO.new("TIT2\x00\x00\x00\x09\x01\x00")
    #     lambda { Mp3file::ID3v2::FrameHeader.new(io, tag) }.
    #       should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
    #   end
    # end
  end
end
