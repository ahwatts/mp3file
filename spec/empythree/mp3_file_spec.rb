require File.dirname(__FILE__) + '/../../lib/empythree'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Empythree::MP3File do
  describe "A 96 kbps 32 kHz Joint Stereo CBR file without any ID3 tags" do
    subject { Empythree::MP3File.new(fixture_file('bret_96.mp3')) }
    its(:id3v2tag?)           { is_expected.to be_falsey }
    its(:id3v1tag?)           { is_expected.to be_falsey }
    its("file.path")          { is_expected.to eq(fixture_file('bret_96.mp3').to_s) }
    its("file.closed?")       { is_expected.to be_truthy }
    its(:file_size)           { is_expected.to eq(fixture_file('bret_96.mp3').size) }
    its(:audio_size)          { is_expected.to eq(fixture_file('bret_96.mp3').size) }
    its(:first_header_offset) { is_expected.to eq(0) }
    its(:mpeg_version)        { is_expected.to eq('MPEG 1') }
    its(:layer)               { is_expected.to eq('Layer III') }
    its(:bitrate)             { is_expected.to eq(96) }
    its(:samplerate)          { is_expected.to eq(32000) }
    its(:mode)                { is_expected.to eq('Joint Stereo') }
    its(:num_frames)          { is_expected.to eq(141) }
    its(:total_samples)       { is_expected.to eq(162432) }
    its(:length)              { is_expected.to eq(5) }
    its(:vbr?)                { is_expected.to be_falsey }
  end

  describe "a 44.1 kHz Stereo VBR file with an average bitrate of 13 kbps without any ID3 tags" do
    subject { Empythree::MP3File.new(fixture_file('bret_vbr_6.mp3')) }
    its(:id3v2tag?)           { is_expected.to be_falsey }
    its(:id3v1tag?)           { is_expected.to be_falsey }
    its("file.path")          { is_expected.to eq(fixture_file('bret_vbr_6.mp3').to_s) }
    its("file.closed?")       { is_expected.to be_truthy }
    its(:file_size)           { is_expected.to eq(fixture_file('bret_vbr_6.mp3').size) }
    its(:audio_size)          { is_expected.to eq(81853) }
    its(:first_header_offset) { is_expected.to eq(0) }
    its(:mpeg_version)        { is_expected.to eq('MPEG 1') }
    its(:layer)               { is_expected.to eq('Layer III') }
    its(:bitrate)             { is_expected.to eq(130) }
    its(:samplerate)          { is_expected.to eq(44100) }
    its(:mode)                { is_expected.to eq('Stereo') }
    its(:num_frames)          { is_expected.to eq(193) }
    its(:total_samples)       { is_expected.to eq(222336) }
    its(:length)              { is_expected.to eq(5) }
    its(:vbr?)                { is_expected.to be_truthy }
  end

  describe "A 96 kbps 32 kHz CBR file with only an ID3v1 tag" do
    subject { Empythree::MP3File.new(fixture_file('bret_id3v1.mp3')) }
    its(:id3v2tag?)           { is_expected.to be_falsey }
    its(:id3v1tag?)           { is_expected.to be_truthy }
    its(:audio_size)          { is_expected.to eq(60912) }
    its(:first_header_offset) { is_expected.to eq(0) }
    its(:mpeg_version)        { is_expected.to eq('MPEG 1') }
    its(:layer)               { is_expected.to eq('Layer III') }
    its(:bitrate)             { is_expected.to eq(96) }
    its(:samplerate)          { is_expected.to eq(32000) }
    its(:mode)                { is_expected.to eq('Joint Stereo') }
    its(:num_frames)          { is_expected.to eq(141) }
    its(:total_samples)       { is_expected.to eq(162432) }
    its(:length)              { is_expected.to eq(5) }
    its(:vbr?)                { is_expected.to be_falsey }
    its('id3v1_tag.artist')   { is_expected.to eq('Cracker') }
    its(:title)               { is_expected.to eq('Hey Bret (You Know What Time I') }
    its(:album)               { is_expected.to eq('Sunrise in the Land of Milk an') }
    its(:comment)             { is_expected.to eq('For testing the empythree gem') }
    its(:year)                { is_expected.to eq('2009') }
    its(:track)               { is_expected.to eq(9) }
    its(:genre)               { is_expected.to eq('Rock') }
  end

  describe "A 96 kbps 34 kHz Joint Stereo CBR file with an ID3v2 tag" do
    subject { Empythree::MP3File.new(fixture_file('bret_id3v2.mp3')) }
    its(:id3v2tag?)           { is_expected.to be_truthy }
    its(:id3v1tag?)           { is_expected.to be_falsey }
    its("file.path")          { is_expected.to eq(fixture_file('bret_id3v2.mp3').to_s) }
    its("file.closed?")       { is_expected.to be_truthy }
    its(:file_size)           { is_expected.to eq(fixture_file('bret_id3v2.mp3').size) }
    its(:audio_size)          { is_expected.to eq(60912) }
    its(:first_header_offset) { is_expected.to eq(528) }
    its(:mpeg_version)        { is_expected.to eq('MPEG 1') }
    its(:layer)               { is_expected.to eq('Layer III') }
    its(:bitrate)             { is_expected.to eq(96) }
    its(:samplerate)          { is_expected.to eq(32000) }
    its(:mode)                { is_expected.to eq('Joint Stereo') }
    its(:num_frames)          { is_expected.to eq(141) }
    its(:total_samples)       { is_expected.to eq(162432) }
    its(:length)              { is_expected.to eq(5) }
    its(:vbr?)                { is_expected.to be_falsey }
  end

  describe "A file consisting only of zeroes" do
    it "raises an error" do
      expect { Empythree::MP3File.new(fixture_file('zeroes.mp3')) }.to raise_error(Empythree::InvalidMP3FileError)
    end
  end
end
