module Mp3file
  class InvalidMP3HeaderError < StandardError; end

  class MP3Header
    attr_reader(:version, :layer, :has_crc, :bitrate, 
      :samplerate, :has_padding, :mode, :mode_extension, 
      :copyright, :original, :emphasis, :samples, :frame_size,
      :side_bytes)

    class MP3HeaderFormat < BinData::Record
      uint8(:sync1, :value => 255, :check_value => lambda { value == 255 })

      bit3(:sync2, :value => 7, :check_value => lambda { value == 7 })
      bit2(:version, :check_value => lambda { value != 1 })
      bit2(:layer, :check_value => lambda { value != 0 })
      bit1(:crc)

      bit4(:bitrate, :check_value => lambda { value != 15 && value != 0 })
      bit2(:samplerate, :check_value => lambda { value != 3 })
      bit1(:padding)
      bit1(:private)

      bit2(:mode)
      bit2(:mode_extension)
      bit1(:copyright)
      bit1(:original)
      bit2(:emphasis, :check_value => lambda { value != 0 })
    end

    MPEG_VERSIONS = [ 'MPEG 2.5', nil, 'MPEG 2', 'MPEG 1' ]
    LAYERS = [ nil, 'Layer III', 'Layer II', 'Layer I' ]
    BITRATES = [
      # MPEG 2.5
      [ nil,
        [  8, 16, 24, 32, 40, 48,  56,  64,  80,  96, 112, 128, 144, 160 ],    # Layer III
        [  8, 16, 24, 32, 40, 48,  56,  64,  80,  96, 112, 128, 144, 160 ],    # Layer II
        [ 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256 ], ], # Layer I
      # reserved
      nil,
      # MPEG 2
      [ nil,
        [  8, 16, 24, 32, 40, 48,  56,  64,  80,  96, 112, 128, 144, 160 ],    # Layer III
        [  8, 16, 24, 32, 40, 48,  56,  64,  80,  96, 112, 128, 144, 160 ],    # Layer II
        [ 32, 48, 56, 64, 80, 96, 112, 128, 144, 160, 176, 192, 224, 256 ], ], # Layer I
      # MPEG 1
      [ nil,
        [ 32, 40, 48,  56,  64,  80,  96, 112, 128, 160, 192, 224, 256, 320 ],   # Layer III
        [ 32, 48, 56,  64,  80,  96, 112, 128, 160, 192, 224, 256, 320, 384 ],   # Layer II
        [ 32, 64, 96, 128, 160, 192, 224, 256, 288, 320, 352, 384, 416, 448 ], ] # Layer I
    ]
    SAMPLERATES = [
      [ 11025, 12000,  8000 ], # MPEG 2.5
      nil,
      [ 22050, 24000, 16000 ], # MPEG 2
      [ 44100, 48000, 32000 ], # MPEG 1
    ]
    MODES = [ 'Stereo', 'Joint Stereo', 'Dual Channel', 'Mono' ]
    SAMPLE_COUNTS = [
      [ nil,  576, 1152, 384 ], # MPEG 2.5, III / II / I
      nil,
      [ nil,  576, 1152, 384 ], # MPEG 2, III / II / I
      [ nil, 1152, 1152, 384 ], # MPEG 1, III / II / I
    ]
    SIDE_BYTES = [
      [ 17, 17, 17,  9 ], # MPEG 2.5, Stereo, J-Stereo, Dual Channel, Mono
      nil,
      [ 17, 17, 17,  9 ], # MPEG 2, Stereo, J-Stereo, Dual Channel, Mono
      [ 32, 32, 32, 17 ], # MPEG 1, Stereo, J-Stereo, Dual Channel, Mono
    ]

    def initialize(io)
      begin
        head = MP3HeaderFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidMP3HeaderError, ve.message
      end

      @version = MPEG_VERSIONS[head.version]
      @layer = LAYERS[head.layer]
      @has_crc = head.crc == 0
      @bitrate = BITRATES[head.version][head.layer][head.bitrate - 1] * 1000
      @samplerate = SAMPLERATES[head.version][head.samplerate]
      @has_padding = head.padding == 1
      @mode = MODES[head.mode]
      @samples = SAMPLE_COUNTS[head.version][head.layer]

      slot_size = layer == 'Layer I' ? 4 : 1
      pad_slots = has_padding ? 1 : 0
      @frame_size = (((samples.to_f * bitrate.to_f) / (8 * slot_size.to_f * samplerate.to_f)) + pad_slots).to_i * slot_size
      @side_bytes = SIDE_BYTES[head.version][head.mode]
    end
  end
end
