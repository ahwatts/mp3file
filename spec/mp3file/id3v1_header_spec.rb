require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::ID3v1Header do
  it "rejects an ID3v1 tag if it doesn't begin with TAG" do
    lambda { Mp3file::ID3v1Header.new(StringIO.new("\x00" * 128)) }.
      should(raise_error(Mp3file::InvalidID3v1HeaderError))
  end
end
