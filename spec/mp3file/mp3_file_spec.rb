require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::MP3File do
  describe "A 96 kbps 34 kHz Joint Stereo CBR file without any ID3 tags" do
    subject { Mp3file::MP3File.new(fixture_file('bret_96.mp3')) }
    its(:id3v2tag?) { should == false }
    its("file.path") { should == fixture_file('bret_96.mp3').to_s }
    its("file.closed?") { should == true }
    its(:file_size) { should == fixture_file('bret_96.mp3').size }
    its(:audio_size) { should == fixture_file('bret_96.mp3').size }
    its(:first_header_offset) { should == 0 }
    its(:mpeg_version) { should == 'MPEG 1' }
    its(:layer) { should == 'Layer III' }
    its(:bitrate) { should == 96 }
    its(:samplerate) { should == 32000 }
    its(:mode) { should == 'Joint Stereo' }
    its(:num_frames) { should == 141 }
    its(:total_samples) { should == 162432 }
    its(:length) { should == 5 }
    its(:vbr?) { should == false }
  end

  describe "a 44.1 kHz Stereo VBR file with an average bitrate of 13 kbps without any ID3 tags" do
    subject { Mp3file::MP3File.new(fixture_file('bret_vbr_6.mp3')) }
    its(:id3v2tag?) { should == false }
    its("file.path") { should == fixture_file('bret_vbr_6.mp3').to_s }
    its("file.closed?") { should == true }
    its(:file_size) { should == fixture_file('bret_vbr_6.mp3').size }
    its(:audio_size) { should == 81853 }
    its(:first_header_offset) { should == 0 }
    its(:mpeg_version) { should == 'MPEG 1' }
    its(:layer) { should == 'Layer III' }
    its(:bitrate) { should == 130 }
    its(:samplerate) { should == 44100 }
    its(:mode) { should == 'Stereo' }
    its(:num_frames) { should == 193 }
    its(:total_samples) { should == 222336 }
    its(:length) { should == 5 }
    its(:vbr?) { should == true }
  end

  # describe "A 96 kbps 34 kHz Joint Stereo CBR file with an ID3v2 tag" do
  #   subject { Mp3file::MP3File.new(fixture_file('bret_id3v2.mp3')) }
  #   its(:id3v2tag?) { should == true }
  #   its("file.path") { should == fixture_file('bret_id3v2.mp3').to_s }
  #   its("file.closed?") { should == true }
  #   its(:file_size) { should == fixture_file('bret_id3v2.mp3').size }
  # end
end
