require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::MP3File do
  describe "A 96 kbps 32 kHz Joint Stereo CBR file without a Xing header or any ID3 tags" do
    path = fixture_file("bret_96_no_xing.mp3")
    subject { Mp3file::MP3File.new(path) }

    describe '#id3v2tag?' do
      subject { super().id3v2tag? }
      it { is_expected.to eq(false) }
    end

    describe '#id3v1tag?' do
      subject { super().id3v1tag? }
      it { is_expected.to eq(false) }
    end

    describe '#file' do
      subject { super().file }
      describe '#path' do
        subject { super().path }
        it { is_expected.to eq(path.to_s) }
      end
    end

    describe '#file' do
      subject { super().file }
      describe '#closed?' do
        subject { super().closed? }
        it { is_expected.to eq(true) }
      end
    end

    describe '#file_size' do
      subject { super().file_size }
      it { is_expected.to eq(path.size) }
    end

    describe '#audio_size' do
      subject { super().audio_size }
      it { is_expected.to eq(path.size) }
    end

    describe '#first_header_offset' do
      subject { super().first_header_offset }
      it { is_expected.to eq(0) }
    end

    describe '#mpeg_version' do
      subject { super().mpeg_version }
      it { is_expected.to eq('MPEG 1') }
    end

    describe '#layer' do
      subject { super().layer }
      it { is_expected.to eq('Layer III') }
    end

    describe '#bitrate' do
      subject { super().bitrate }
      it { is_expected.to eq(96) }
    end

    describe '#samplerate' do
      subject { super().samplerate }
      it { is_expected.to eq(32000) }
    end

    describe '#mode' do
      subject { super().mode }
      it { is_expected.to eq('Joint Stereo') }
    end

    describe '#num_frames' do
      subject { super().num_frames }
      it { is_expected.to eq(140) }
    end

    describe '#total_samples' do
      subject { super().total_samples }
      it { is_expected.to eq(161280) }
    end

    describe '#length' do
      subject { super().length }
      it { is_expected.to eq(5.04) }
    end

    describe '#vbr?' do
      subject { super().vbr? }
      it { is_expected.to eq(false) }
    end
  end

  describe "A 96 kbps 32 kHz Joint Stereo CBR file with a Xing \"Info\" header and no ID3 tags" do
    path = fixture_file("bret_96.mp3")
    subject { Mp3file::MP3File.new(path) }

    describe '#id3v2tag?' do
      subject { super().id3v2tag? }
      it { is_expected.to eq(false) }
    end

    describe '#id3v1tag?' do
      subject { super().id3v1tag? }
      it { is_expected.to eq(false) }
    end

    describe '#file' do
      subject { super().file }
      describe '#path' do
        subject { super().path }
        it { is_expected.to eq(path.to_s) }
      end
    end

    describe '#file' do
      subject { super().file }
      describe '#closed?' do
        subject { super().closed? }
        it { is_expected.to eq(true) }
      end
    end

    describe '#file_size' do
      subject { super().file_size }
      it { is_expected.to eq(path.size) }
    end

    describe '#audio_size' do
      subject { super().audio_size }
      it { is_expected.to eq(path.size) }
    end

    describe '#first_header_offset' do
      subject { super().first_header_offset }
      it { is_expected.to eq(0) }
    end

    describe '#mpeg_version' do
      subject { super().mpeg_version }
      it { is_expected.to eq('MPEG 1') }
    end

    describe '#layer' do
      subject { super().layer }
      it { is_expected.to eq('Layer III') }
    end

    describe '#bitrate' do
      subject { super().bitrate }
      it { is_expected.to eq(96) }
    end

    describe '#samplerate' do
      subject { super().samplerate }
      it { is_expected.to eq(32000) }
    end

    describe '#mode' do
      subject { super().mode }
      it { is_expected.to eq('Joint Stereo') }
    end

    describe '#num_frames' do
      subject { super().num_frames }
      it { is_expected.to eq(140) }
    end

    describe '#total_samples' do
      subject { super().total_samples }
      it { is_expected.to eq(161280) }
    end

    describe '#length' do
      subject { super().length }
      it { is_expected.to eq(5.04) }
    end

    describe '#vbr?' do
      subject { super().vbr? }
      it { is_expected.to eq(false) }
    end
  end

  describe "a 44.1 kHz Stereo VBR file with an average bitrate of 130 kbps without any ID3 tags" do
    path = fixture_file("bret_vbr_6.mp3")
    subject { Mp3file::MP3File.new(path) }

    describe '#id3v2tag?' do
      subject { super().id3v2tag? }
      it { is_expected.to eq(false) }
    end

    describe '#id3v1tag?' do
      subject { super().id3v1tag? }
      it { is_expected.to eq(false) }
    end

    describe '#file' do
      subject { super().file }
      describe '#path' do
        subject { super().path }
        it { is_expected.to eq(path.to_s) }
      end
    end

    describe '#file' do
      subject { super().file }
      describe '#closed?' do
        subject { super().closed? }
        it { is_expected.to eq(true) }
      end
    end

    describe '#file_size' do
      subject { super().file_size }
      it { is_expected.to eq(path.size) }
    end

    describe '#audio_size' do
      subject { super().audio_size }
      it { is_expected.to eq(81853) }
    end

    describe '#first_header_offset' do
      subject { super().first_header_offset }
      it { is_expected.to eq(0) }
    end

    describe '#mpeg_version' do
      subject { super().mpeg_version }
      it { is_expected.to eq('MPEG 1') }
    end

    describe '#layer' do
      subject { super().layer }
      it { is_expected.to eq('Layer III') }
    end

    describe '#bitrate' do
      subject { super().bitrate }
      it { is_expected.to be_within(0.005).of(129.88) }
    end

    describe '#samplerate' do
      subject { super().samplerate }
      it { is_expected.to eq(44100) }
    end

    describe '#mode' do
      subject { super().mode }
      it { is_expected.to eq('Stereo') }
    end

    describe '#num_frames' do
      subject { super().num_frames }
      it { is_expected.to eq(193) }
    end

    describe '#total_samples' do
      subject { super().total_samples }
      it { is_expected.to eq(222336) }
    end

    describe '#length' do
      subject { super().length }
      it { is_expected.to be_within(0.005).of(5.04) }
    end

    describe '#vbr?' do
      subject { super().vbr? }
      it { is_expected.to eq(true) }
    end
  end

  describe "A 96 kbps 32 kHz CBR file with no Xing header and only an ID3v1 tag" do
    subject { Mp3file::MP3File.new(fixture_file('bret_id3v1_no_xing.mp3')) }

    describe '#id3v2tag?' do
      subject { super().id3v2tag? }
      it { is_expected.to eq(false) }
    end

    describe '#id3v1tag?' do
      subject { super().id3v1tag? }
      it { is_expected.to eq(true) }
    end

    describe '#audio_size' do
      subject { super().audio_size }
      it { is_expected.to eq(60480) }
    end

    describe '#first_header_offset' do
      subject { super().first_header_offset }
      it { is_expected.to eq(0) }
    end

    describe '#mpeg_version' do
      subject { super().mpeg_version }
      it { is_expected.to eq('MPEG 1') }
    end

    describe '#layer' do
      subject { super().layer }
      it { is_expected.to eq('Layer III') }
    end

    describe '#bitrate' do
      subject { super().bitrate }
      it { is_expected.to eq(96) }
    end

    describe '#samplerate' do
      subject { super().samplerate }
      it { is_expected.to eq(32000) }
    end

    describe '#mode' do
      subject { super().mode }
      it { is_expected.to eq('Joint Stereo') }
    end

    describe '#num_frames' do
      subject { super().num_frames }
      it { is_expected.to eq(140) }
    end

    describe '#total_samples' do
      subject { super().total_samples }
      it { is_expected.to eq(161280) }
    end

    describe '#length' do
      subject { super().length }
      it { is_expected.to be_within(0.005).of(5.04) }
    end

    describe '#vbr?' do
      subject { super().vbr? }
      it { is_expected.to eq(false) }
    end

    describe '#id3v1_tag' do
      subject { super().id3v1_tag }
      describe '#artist' do
        subject { super().artist }
        it { is_expected.to eq('Cracker') }
      end
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq('Hey Bret (You Know What Time I') }
    end

    describe '#album' do
      subject { super().album }
      it { is_expected.to eq('Sunrise in the Land of Milk an') }
    end

    describe '#comment' do
      subject { super().comment }
      it { is_expected.to eq('For testing the mp3file gem') }
    end

    describe '#year' do
      subject { super().year }
      it { is_expected.to eq('2009') }
    end

    describe '#track' do
      subject { super().track }
      it { is_expected.to eq(9) }
    end

    describe '#genre' do
      subject { super().genre }
      it { is_expected.to eq('Rock') }
    end
  end

  describe "A 96 kbps 32 kHz CBR file with a Xing \"Info\" header and only an ID3v1 tag" do
    subject { Mp3file::MP3File.new(fixture_file('bret_id3v1.mp3')) }

    describe '#id3v2tag?' do
      subject { super().id3v2tag? }
      it { is_expected.to eq(false) }
    end

    describe '#id3v1tag?' do
      subject { super().id3v1tag? }
      it { is_expected.to eq(true) }
    end

    describe '#audio_size' do
      subject { super().audio_size }
      it { is_expected.to eq(60912) }
    end

    describe '#first_header_offset' do
      subject { super().first_header_offset }
      it { is_expected.to eq(0) }
    end

    describe '#mpeg_version' do
      subject { super().mpeg_version }
      it { is_expected.to eq('MPEG 1') }
    end

    describe '#layer' do
      subject { super().layer }
      it { is_expected.to eq('Layer III') }
    end

    describe '#bitrate' do
      subject { super().bitrate }
      it { is_expected.to eq(96) }
    end

    describe '#samplerate' do
      subject { super().samplerate }
      it { is_expected.to eq(32000) }
    end

    describe '#mode' do
      subject { super().mode }
      it { is_expected.to eq('Joint Stereo') }
    end

    describe '#num_frames' do
      subject { super().num_frames }
      it { is_expected.to eq(140) }
    end

    describe '#total_samples' do
      subject { super().total_samples }
      it { is_expected.to eq(161280) }
    end

    describe '#length' do
      subject { super().length }
      it { is_expected.to be_within(0.005).of(5.04) }
    end

    describe '#vbr?' do
      subject { super().vbr? }
      it { is_expected.to eq(false) }
    end

    describe '#id3v1_tag' do
      subject { super().id3v1_tag }
      describe '#artist' do
        subject { super().artist }
        it { is_expected.to eq('Cracker') }
      end
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq('Hey Bret (You Know What Time I') }
    end

    describe '#album' do
      subject { super().album }
      it { is_expected.to eq('Sunrise in the Land of Milk an') }
    end

    describe '#comment' do
      subject { super().comment }
      it { is_expected.to eq('For testing the mp3file gem') }
    end

    describe '#year' do
      subject { super().year }
      it { is_expected.to eq('2009') }
    end

    describe '#track' do
      subject { super().track }
      it { is_expected.to eq(9) }
    end

    describe '#genre' do
      subject { super().genre }
      it { is_expected.to eq('Rock') }
    end
  end

  describe "A 96 kbps 34 kHz Joint Stereo CBR file with a Xing \"Info\" header and an ID3v2 tag" do
    subject { Mp3file::MP3File.new(fixture_file('bret_id3v2.mp3')) }

    describe '#id3v2tag?' do
      subject { super().id3v2tag? }
      it { is_expected.to eq(true) }
    end

    describe '#id3v1tag?' do
      subject { super().id3v1tag? }
      it { is_expected.to eq(false) }
    end

    describe '#file' do
      subject { super().file }
      describe '#path' do
        subject { super().path }
        it { is_expected.to eq(fixture_file('bret_id3v2.mp3').to_s) }
      end
    end

    describe '#file' do
      subject { super().file }
      describe '#closed?' do
        subject { super().closed? }
        it { is_expected.to eq(true) }
      end
    end

    describe '#file_size' do
      subject { super().file_size }
      it { is_expected.to eq(fixture_file('bret_id3v2.mp3').size) }
    end

    describe '#audio_size' do
      subject { super().audio_size }
      it { is_expected.to eq(60912) }
    end

    describe '#first_header_offset' do
      subject { super().first_header_offset }
      it { is_expected.to eq(528) }
    end

    describe '#mpeg_version' do
      subject { super().mpeg_version }
      it { is_expected.to eq('MPEG 1') }
    end

    describe '#layer' do
      subject { super().layer }
      it { is_expected.to eq('Layer III') }
    end

    describe '#bitrate' do
      subject { super().bitrate }
      it { is_expected.to eq(96) }
    end

    describe '#samplerate' do
      subject { super().samplerate }
      it { is_expected.to eq(32000) }
    end

    describe '#mode' do
      subject { super().mode }
      it { is_expected.to eq('Joint Stereo') }
    end

    describe '#num_frames' do
      subject { super().num_frames }
      it { is_expected.to eq(140) }
    end

    describe '#total_samples' do
      subject { super().total_samples }
      it { is_expected.to eq(161280) }
    end

    describe '#length' do
      subject { super().length }
      it { is_expected.to be_within(0.001).of(5.04) }
    end

    describe '#vbr?' do
      subject { super().vbr? }
      it { is_expected.to eq(false) }
    end
  end

  describe "A file consisting only of zeroes" do
    it "raises an error" do
      expect { Mp3file::MP3File.new(fixture_file('zeroes.mp3')) }.
        to(raise_error(Mp3file::InvalidMP3FileError))
    end
  end
end
