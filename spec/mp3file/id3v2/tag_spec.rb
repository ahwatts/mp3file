require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::Tag do
  it "raises an error if the first 3 bytes don't say \"ID3\"" do
    io = StringIO.new("ID2" + ("\x00" * 7))
    lambda { Mp3file::ID3v2::Tag.new(io) }.should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end
end
