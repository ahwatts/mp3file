require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::MP3File do
  # describe "A 96 kbps 34 kHz Joint Stereo CBR file without an ID3v2 tag" do
  #   subject { Mp3file::MP3File.new(fixture_file('bret_96.mp3')) }
  #   its(:id3v2tag?) { should == false }
  #   its("file.path") { should == fixture_file('bret_96.mp3').to_s }
  #   its("file.closed?") { should == true }
  #   its(:file_size) { should == fixture_file('bret_96.mp3').size }
  #   its(:audio_size) { should == fixture_file('bret_96.mp3').size }
  # end

  # describe "A 96 kbps 34 kHz Joint Stereo CBR file with an ID3v2 tag" do
  #   subject { Mp3file::MP3File.new(fixture_file('bret_id3v2.mp3')) }
  #   its(:id3v2tag?) { should == true }
  #   its("file.path") { should == fixture_file('bret_id3v2.mp3').to_s }
  #   its("file.closed?") { should == true }
  #   its(:file_size) { should == fixture_file('bret_id3v2.mp3').size }
  # end
end
