require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::ID3v1Tag do
  it "rejects an ID3v1 tag if it doesn't begin with TAG" do
    lambda { Mp3file::ID3v1Tag.parse(StringIO.new("\x00" * 128)) }.
      should(raise_error(Mp3file::InvalidID3v1TagError))
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

    its(:title) { should == 'Big Dipper' }
    its(:artist) { should == 'Cracker' }
    its(:album) { should == 'The Golden Age' }
    its(:year) { should == '1996' }
    its(:comment) { should == 'This is a comment' }
    its(:track) { should == nil }
    its(:genre) { should == 'Rock' }
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

    its(:title) { should == 'Big Dipper' }
    its(:artist) { should == 'Cracker' }
    its(:album) { should == 'The Golden Age' }
    its(:year) { should == '1996' }
    its(:comment) { should == 'This is a comment' }
    its(:track) { should == 3 }
    its(:genre) { should == 'Rock' }
  end

  describe "When created with a blank ID3v1 tag" do
    subject { Mp3file::ID3v1Tag.parse(StringIO.new("TAG" + ("\x00" * 125))) }
    its(:title) { should == nil }
    its(:artist) { should == nil }
    its(:album) { should == nil }
    its(:comment) { should == nil }
    its(:track) { should == nil }
    its(:genre) { should == 'Blues' }
  end
end
