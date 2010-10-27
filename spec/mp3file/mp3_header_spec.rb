require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

describe Mp3file::MP3Header do
  describe "#version" do
    it "returns the MPEG version" do
      Mp3file::MP3Header.new([ 0xFF, 0b1110_0000, 0, 0 ]).version.
        should == :mpeg_2_5
      Mp3file::MP3Header.new([ 0xFF, 0b1110_1000, 0, 0 ]).version.
        should == nil
      Mp3file::MP3Header.new([ 0xFF, 0b1111_0000, 0, 0 ]).version.
        should == :mpeg_2
      Mp3file::MP3Header.new([ 0xFF, 0b1111_1000, 0, 0 ]).version.
        should == :mpeg_1
    end
  end

  describe "#layer" do
    it "returns the MPEG layer" do
      Mp3file::MP3Header.new([ 0xFF, 0b1111_0000, 0, 0 ]).layer.
        should == nil
      Mp3file::MP3Header.new([ 0xFF, 0b1111_0010, 0, 0 ]).layer.
        should == :layer_3
      Mp3file::MP3Header.new([ 0xFF, 0b1111_0100, 0, 0 ]).layer.
        should == :layer_2
      Mp3file::MP3Header.new([ 0xFF, 0b1111_0110, 0, 0 ]).layer.
        should == :layer_1
    end
  end

  describe "#has_crc" do
    it "returns whether or not there is a CRC present" do
      Mp3file::MP3Header.new([ 0xFF, 0b1111_1010, 0, 0 ]).has_crc.
        should == true
      Mp3file::MP3Header.new([ 0xFF, 0b1111_1011, 0, 0 ]).has_crc.
        should == false
    end
  end

  # bitrates & samplerates from: http://www.codeproject.com/KB/audio-video/mpegaudioinfo.aspx

  describe "#bitrate" do
    bits = (1..14).to_a
    combinations = [
      [ "MPEG 1 Layer I",     0xFF, [ 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448 ] ],
      [ "MPEG 1 Layer II",    0xFD, [ 32, 48, 56,  64,  80,  96, 112, 128, 160, 192, 224, 256, 320, 384 ] ],
      [ "MPEG 1 Layer III",   0xFB, [ 32, 40, 48,  56,  64,  80,  96, 112, 128, 160, 192, 224, 256, 320 ] ],
      [ "MPEG 2 Layer I",     0xF7, [ 32, 48, 56,  64,  80,  96, 112, 128, 144, 160, 176, 192, 224, 256 ] ],
      [ "MPEG 2 Layer II",    0xF5, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
      [ "MPEG 2 Layer III",   0xF3, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
      [ "MPEG 2.5 Layer I",   0xE7, [ 32, 48, 56,  64,  80,  96, 112, 128, 144, 160, 176, 192, 224, 256 ] ],
      [ "MPEG 2.5 Layer II",  0xE5, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
      [ "MPEG 2.5 Layer III", 0xE3, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
    ]
    combinations.each do |name, byte2, brs|
      context "for #{name}" do
        bits.zip(brs).each do |bits, br|
          it("returns %d kbps for %04b" % [ br, bits ]) do
            Mp3file::MP3Header.new([ 0xFF, byte2, bits << 4, 0 ]).bitrate.
              should == br*1000
          end
        end
      end
    end
  end

  describe "#samplerate" do
    bits = (0..2).to_a
    combinations = [
      [ "MPEG 1",   0xFF, [ 44100, 48000, 32000 ] ],
      [ "MPEG 2",   0xF5, [ 22050, 24000, 16000 ] ],
      [ "MPEG 2.5", 0xE3, [ 11025, 12000,  8000 ] ],
    ]
    combinations.each do |name, byte2, srs|
      context "for #{name}" do
        bits.zip(srs).each do |bits, sr|
          it("returns %d Hz for %02b" % [ sr, bits ]) do
            Mp3file::MP3Header.new([ 0xFF, byte2, 0x10 + bits << 2, 0 ]).samplerate.
              should == sr
          end
        end
      end
    end
  end

  describe "#has_padding" do
    it "returns if the frame is padded" do
      Mp3file::MP3Header.new([ 0xFF, 0xFB, 0b1001_1000, 0 ]).has_padding.
        should == false
      Mp3file::MP3Header.new([ 0xFF, 0xFB, 0b1001_1010, 0 ]).has_padding.
        should == true
    end
  end

  describe "#mode" do
    it "returns the mode" do
      Mp3file::MP3Header.new([ 0xFF, 0xFB, 0x92, 0b0000_0000 ]).mode.
        should == :stereo
      Mp3file::MP3Header.new([ 0xFF, 0xFB, 0x92, 0b0100_0000 ]).mode.
        should == :joint_stereo
      Mp3file::MP3Header.new([ 0xFF, 0xFB, 0x92, 0b1000_0000 ]).mode.
        should == :dual_channel
      Mp3file::MP3Header.new([ 0xFF, 0xFB, 0x92, 0b1100_0000 ]).mode.
        should == :mono
    end
  end

  describe "#samples" do
    combinations = [
      [ "MPEG 1 Layer I",     0xFF,  384 ],
      [ "MPEG 1 Layer II",    0xFD, 1152 ],
      [ "MPEG 1 Layer III",   0xFB, 1152 ],
      [ "MPEG 2 Layer I",     0xF7,  384 ],
      [ "MPEG 2 Layer II",    0xF5, 1152 ],
      [ "MPEG 2 Layer III",   0xF3,  576 ],
      [ "MPEG 2.5 Layer I",   0xE7,  384 ],
      [ "MPEG 2.5 Layer II",  0xE5, 1152 ],
      [ "MPEG 2.5 Layer III", 0xE3,  576 ],
    ]
    combinations.each do |name, byte2, samples|
      context "for #{name}" do
        it("returns %d samples" % [ samples ]) do
          Mp3file::MP3Header.new([ 0xFF, byte2, 0x92, 0xC0 ]).samples.
            should == samples
        end
      end
    end
  end

  describe "#frame_size" do
    it "returns the frame size" do
      pending("write this test")
    end
  end
end
