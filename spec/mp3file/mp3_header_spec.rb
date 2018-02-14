require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::MP3Header do
  it "raises an error if the first byte isn't 255" do
    expect { Mp3file::MP3Header.new(create_io([ 0xAA, 0xF8, 0x10, 0x01 ])) }.
      to(raise_error(Mp3file::InvalidMP3HeaderError))
  end

  it "raises an error if the second sync byte is wrong" do
    expect { Mp3file::MP3Header.new(create_io([ 0xFF, 0xB8, 0x10, 0x01 ])) }.
      to(raise_error(Mp3file::InvalidMP3HeaderError))
  end

  describe "#version" do
    [ [ [ 0xFF, 0b1110_0010, 0x10, 0x01 ], 'MPEG 2.5' ],
      [ [ 0xFF, 0b1111_0010, 0x10, 0x01 ], 'MPEG 2' ],
      [ [ 0xFF, 0b1111_1010, 0x10, 0x01 ], 'MPEG 1' ],
    ].each do |bytes, version|
      it "recognizes #{version}" do
        h = Mp3file::MP3Header.new(create_io(bytes))
        expect(h.version).to eq(version)
      end
    end

    it "raises an error on an invalid version" do
      expect { Mp3file::MP3Header.new(create_io([ 0xFF, 0b1110_1010, 0x10, 0x01 ])) }.
        to(raise_error(Mp3file::InvalidMP3HeaderError))
    end
  end

  describe "#layer" do
    [ [ [ 0xFF, 0b1111_1010, 0x10, 0x01 ], 'Layer III' ],
      [ [ 0xFF, 0b1111_1100, 0x10, 0x01 ], 'Layer II' ],
      [ [ 0xFF, 0b1111_1110, 0x10, 0x01 ], 'Layer I' ],
    ].each do |bytes, layer|
      it "recognizes #{layer}" do
        h = Mp3file::MP3Header.new(create_io(bytes))
        expect(h.layer).to eq(layer)
      end
    end

    it "raises an error on an invalid version" do
      expect { Mp3file::MP3Header.new(create_io([ 0xFF, 0b1111_1000, 0x10, 0x01 ])) }.
        to(raise_error(Mp3file::InvalidMP3HeaderError))
    end
  end

  describe "#has_crc" do
    it "detects when a CRC is present" do
      h = Mp3file::MP3Header.new(create_io([ 0xFF, 0b1111_1010, 0x10, 0x01 ]))
      h.has_crc == true
    end
    it "detects when there is not a CRC present" do
      h = Mp3file::MP3Header.new(create_io([ 0xFF, 0b1111_1011, 0x10, 0x01 ]))
      h.has_crc == true
    end
  end

  describe "#bitrate" do
    [ [ "MPEG 1 Layer I",     0xFF, [ 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448 ] ],
      [ "MPEG 1 Layer II",    0xFD, [ 32, 48, 56,  64,  80,  96, 112, 128, 160, 192, 224, 256, 320, 384 ] ],
      [ "MPEG 1 Layer III",   0xFB, [ 32, 40, 48,  56,  64,  80,  96, 112, 128, 160, 192, 224, 256, 320 ] ],
      [ "MPEG 2 Layer I",     0xF7, [ 32, 48, 56,  64,  80,  96, 112, 128, 144, 160, 176, 192, 224, 256 ] ],
      [ "MPEG 2 Layer II",    0xF5, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
      [ "MPEG 2 Layer III",   0xF3, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
      [ "MPEG 2.5 Layer I",   0xE7, [ 32, 48, 56,  64,  80,  96, 112, 128, 144, 160, 176, 192, 224, 256 ] ],
      [ "MPEG 2.5 Layer II",  0xE5, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
      [ "MPEG 2.5 Layer III", 0xE3, [  8, 16, 24,  32,  40,  48,  56,  64,  80,  96, 112, 128, 144, 160 ] ],
    ].each do |version_layer, byte2, bitrates|
      context "for #{version_layer}" do
        bitrates.each_with_index do |br, i|
          it "detects #{br} kbps" do
            io = create_io([ 0xFF, byte2, (i + 1) << 4, 0x01 ])
            h = Mp3file::MP3Header.new(io)
            expect(h.bitrate).to eq(br * 1000)
          end
        end

        it "rejects a free bitrate" do
          io = create_io([ 0xFF, byte2, 0x00, 0x01 ])
          expect { Mp3file::MP3Header.new(io) }.to(raise_error(Mp3file::InvalidMP3HeaderError))
        end

        it "rejects a bad bitrate" do
          io = create_io([ 0xFF, byte2, 0xF0, 0x01 ])
          expect { Mp3file::MP3Header.new(io) }.to(raise_error(Mp3file::InvalidMP3HeaderError))
        end
      end
    end
  end

  describe "#samplerate" do
    [ [ "MPEG 1",   0xFF, [ 44100, 48000, 32000 ] ],
      [ "MPEG 2",   0xF5, [ 22050, 24000, 16000 ] ],
      [ "MPEG 2.5", 0xE3, [ 11025, 12000,  8000 ] ],
    ].each do |version, byte2, srs|
      context "for #{version}" do
        srs.each_with_index do |sr, i|
          it "detects #{sr} Hz" do
            io = create_io([ 0xFF, byte2, 0x10 + (i << 2), 0x01 ])
            h = Mp3file::MP3Header.new(io)
            expect(h.samplerate).to eq(sr)
          end
        end

        it "rejects reserved samplerate values" do
          io = create_io([ 0xFF, byte2, 0x1C, 0x01 ])
          expect { Mp3file::MP3Header.new(io) }.to(raise_error(Mp3file::InvalidMP3HeaderError))
        end
      end
    end
  end

  describe "#has_padding" do
    it "detects if the frame is padded" do
      io = create_io([ 0xFF, 0xFB, 0b0001_1010, 0x01 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.has_padding).to eq(true)
    end

    it "detects if the frame is not padded" do
      io = create_io([ 0xFF, 0xFB, 0b0001_1000, 0x01 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.has_padding).to eq(false)
    end
  end

  describe "#mode" do
    it "detects Stereo" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0000_0001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.mode).to eq('Stereo')
    end

    it "detects Joint Stereo" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0100_0001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.mode).to eq('Joint Stereo')
    end

    it "detects Dual Channel" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b1000_0001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.mode).to eq('Dual Channel')
    end

    it "detects Mono" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b1100_0001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.mode).to eq('Mono')
    end
  end

  describe "#mode_extension" do
    context "For Layers I & II" do
      it "detects bands 4 to 31" do
        io = create_io([ 0xFF, 0xFE, 0x92, 0b0100_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq('bands 4 to 31')
      end

      it "detects bands 8 to 31" do
        io = create_io([ 0xFF, 0xFD, 0x92, 0b0101_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq('bands 8 to 31')
      end

      it "detects bands 12 to 31" do
        io = create_io([ 0xFF, 0xFE, 0x92, 0b0110_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq('bands 12 to 31')
      end

      it "detects bands 16 to 31" do
        io = create_io([ 0xFF, 0xFD, 0x92, 0b0111_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq('bands 16 to 31')
      end
    end

    context "For Layer III" do
      it "detects neither mode extension" do
        io = create_io([ 0xFF, 0xFB, 0x92, 0b0100_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq(nil)
      end

      it "detects only Intensity Stereo" do
        io = create_io([ 0xFF, 0xFB, 0x92, 0b0101_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq('Intensity Stereo')
      end

      it "detects only M/S Stereo" do
        io = create_io([ 0xFF, 0xFB, 0x92, 0b0110_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq('M/S Stereo')
      end

      it "detects both Intensity Stereo & M/S Stereo" do
        io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq([ 'Intensity Stereo', 'M/S Stereo' ])
      end
    end

    context "for non-Joint-Stereo headers" do
      it "should return no mode extension for Stereo" do
        io = create_io([ 0xFF, 0xFE, 0x92, 0b0011_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq(nil)
      end

      it "should return no mode extension for Dual Channel" do
        io = create_io([ 0xFF, 0xFD, 0x92, 0b1011_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq(nil)
      end

      it "should return no mode extension for Mono" do
        io = create_io([ 0xFF, 0xFB, 0x92, 0b1111_0001 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.mode_extension).to eq(nil)
      end
    end
  end

  describe "#copyright" do
    it "detects copyrighted material" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_1001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.copyright).to eq(true)
    end

    it "detects non-copyrighted material" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.copyright).to eq(false)
    end
  end

  describe "#original" do
    it "detects original material" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0101 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.original).to eq(true)
    end

    it "detects non-original material" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.original).to eq(false)
    end
  end

  describe "#emphasis" do
    it "detects no emphasis" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0000 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.emphasis).to eq('none')
    end

    it "detects 50/15 ms" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0001 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.emphasis).to eq('50/15 ms')
    end

    it "raises an error on 2" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0010 ])
      expect { Mp3file::MP3Header.new(io) }.to(raise_error(Mp3file::InvalidMP3HeaderError))
    end

    it "detects CCIT J.17" do
      io = create_io([ 0xFF, 0xFB, 0x92, 0b0111_0011 ])
      h = Mp3file::MP3Header.new(io)
      expect(h.emphasis).to eq('CCIT J.17')
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
      it("for #{name}, returns %d samples" % [ samples ]) do
        io = create_io([ 0xFF, byte2, 0x92, 0xC1 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.samples).to eq(samples)
      end
    end
  end

  describe "#frame_size" do
    combinations = [
      [ "MPEG 1 Layer I 32 kbps 32 kHz padded",        0xFF, 0x1B,  52 ],
      [ "MPEG 1 Layer II 56 kbps 48 kHz not padded",   0xFD, 0x34, 168 ],
      [ "MPEG 1 Layer III 64 kbps 44.1 kHz padded",    0xFB, 0x53, 209 ],
      [ "MPEG 2 Layer III 144 kbps 24 kHz not padded", 0xF3, 0xD5, 432 ],
    ]
    combinations.each do |name, byte2, byte3, size|
      it "for #{name}, returns #{size} bytes" do
        io = create_io([ 0xFF, byte2, byte3, 0xC1 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.frame_size).to eq(size)
      end
    end
  end

  describe "#side_bytes" do
    combinations = [
      [ "MPEG 1 Stereo",   0xFF, 0x18, 0x01, 32 ],
      [ "MPEG 1 Mono",     0xFF, 0x18, 0xC1, 17 ],
      [ "MPEG 2 J-Stereo", 0xF3, 0xD5, 0x41, 17 ],
      [ "MPEG 2.5 Mono",   0xE3, 0xD5, 0xC1,  9 ],      
    ]
    combinations.each do |name, b2, b3, b4, side_bytes|
      it "for #{name}, returns #{side_bytes} bytes" do
        io = create_io([ 0xFF, b2, b3, b4 ])
        h = Mp3file::MP3Header.new(io)
        expect(h.side_bytes).to eq(side_bytes)
      end
    end
  end
end
