require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

describe Mp3file::MP3File do
  include CommonHelpers

  describe "#id3v2tag?" do
    context "given an MP3 file that has an ID3v2 tag" do
      it "should return true" do
        mp3 = Mp3file::MP3File.new(fixture_file('bret_id3v2.mp3'))
        mp3.id3v2tag?.should == true
      end
    end

    context "given an MP3 file that has no ID3v2 tag" do
      it "should return false" do
        mp3 = Mp3file::MP3File.new(fixture_file('bret_96.mp3'))
        mp3.id3v2tag?.should == false
      end
    end
  end
end
