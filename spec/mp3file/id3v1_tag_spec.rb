require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::ID3v1Tag do
  it "rejects an ID3v1 tag if it doesn't begin with TAG" do
    expect { Mp3file::ID3v1Tag.parse(StringIO.new("\x00" * 128)) }.
      to(raise_error(Mp3file::InvalidID3v1TagError))
  end

  describe "When created with a properly-formatted ID3v1 tag" do
    subject do
      title = "Big Dipper"; title += "\x00" * (30 - title.size)
      artist = "Cracker"; artist += "\x00" * (30 - artist.size)
      album = "The Golden Age"; album += "\x00" * (30 - album.size)
      year = "1996"
      comment = "This is a comment"; comment += "\x00" * (30 - comment.size)
      genre = 17.chr
      Mp3file::ID3v1Tag.parse(StringIO.new('TAG' + title + artist + album + year + comment + genre))
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq('Big Dipper') }
    end

    describe '#artist' do
      subject { super().artist }
      it { is_expected.to eq('Cracker') }
    end

    describe '#album' do
      subject { super().album }
      it { is_expected.to eq('The Golden Age') }
    end

    describe '#year' do
      subject { super().year }
      it { is_expected.to eq('1996') }
    end

    describe '#comment' do
      subject { super().comment }
      it { is_expected.to eq('This is a comment') }
    end

    describe '#track' do
      subject { super().track }
      it { is_expected.to eq(nil) }
    end

    describe '#genre' do
      subject { super().genre }
      it { is_expected.to eq('Rock') }
    end
  end

  describe "When created with a properly-formatted ID3v1.1 tag" do
    subject do
      title = "Big Dipper"; title += "\x00" * (30 - title.size)
      artist = "Cracker"; artist += "\x00" * (30 - artist.size)
      album = "The Golden Age"; album += "\x00" * (30 - album.size)
      year = "1996"
      comment = "This is a comment"; comment += "\x00" * (29 - comment.size)
      tracknum = 3.chr
      genre = 17.chr
      Mp3file::ID3v1Tag.parse(StringIO.new('TAG' + title + artist + album + year + comment + tracknum + genre))
    end

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq('Big Dipper') }
    end

    describe '#artist' do
      subject { super().artist }
      it { is_expected.to eq('Cracker') }
    end

    describe '#album' do
      subject { super().album }
      it { is_expected.to eq('The Golden Age') }
    end

    describe '#year' do
      subject { super().year }
      it { is_expected.to eq('1996') }
    end

    describe '#comment' do
      subject { super().comment }
      it { is_expected.to eq('This is a comment') }
    end

    describe '#track' do
      subject { super().track }
      it { is_expected.to eq(3) }
    end

    describe '#genre' do
      subject { super().genre }
      it { is_expected.to eq('Rock') }
    end
  end

  describe "When created with a blank ID3v1 tag" do
    subject { Mp3file::ID3v1Tag.parse(StringIO.new("TAG" + ("\x00" * 125))) }

    describe '#title' do
      subject { super().title }
      it { is_expected.to eq("") }
    end

    describe '#artist' do
      subject { super().artist }
      it { is_expected.to eq("") }
    end

    describe '#album' do
      subject { super().album }
      it { is_expected.to eq("") }
    end

    describe '#comment' do
      subject { super().comment }
      it { is_expected.to eq("") }
    end

    describe '#track' do
      subject { super().track }
      it { is_expected.to eq(nil) }
    end

    describe '#genre' do
      subject { super().genre }
      it { is_expected.to eq('Blues') }
    end
  end
end
