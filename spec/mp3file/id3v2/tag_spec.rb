require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::Tag do
  it "raises an error if the first 3 bytes don't say \"ID3\"" do
    io = StringIO.new("ID2\x03\x00\x00\x00\x00\x00\x00")
    lambda { Mp3file::ID3v2::Tag.new(io) }.should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end

  it "raises an error if the major version is more than 4 (e.g., no ID3v2.5.0+)" do
    io = StringIO.new("ID3\x05\x00\x00\x00\x00\x00\x00")
    lambda { Mp3file::ID3v2::Tag.new(io) }.should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end

  describe "#version" do
    it "detects ID3v2.2.0" do
      t = Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00"))
      t.version.should == Mp3file::ID3v2::ID3V2_2_0
    end

    it "detects ID3v2.3.0" do
      t = Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x00\x00\x00\x00\x00"))
      t.version.should == Mp3file::ID3v2::ID3V2_3_0
    end

    it "detects ID3v2.4.0" do
      t = Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x04\x00\x00\x00\x00\x00\x00"))
      t.version.should == Mp3file::ID3v2::ID3V2_4_0
    end
  end
end
