module Mp3file
  class MP3Header
    attr_reader(:version, :layer, :has_crc, :bitrate, 
      :samplerate, :has_padding, :mode, :mode_extension, 
      :copyright, :original, :emphasis, :samples, :frame_size,
      :side_bytes, :errorstr)

    MPEG_VERSIONS = [ :mpeg_2_5, nil, :mpeg_2, :mpeg_1 ]
    LAYERS = [ nil, :layer_3, :layer_2, :layer_1 ]
    BITRATES = {
      :mpeg_1 => {
        :layer_1 => [
          :free, 32, 64, 96, 128, 160, 192, 224, 
          256, 288, 320, 352, 384, 416, 448, :bad ],
        :layer_2 => [
          :free, 32, 48, 56, 64, 80, 96, 112,
          128, 160, 192, 224, 256, 320, 384, :bad ],
        :layer_3 => [
          :free, 32, 40, 48, 56, 64, 80, 96,
          112, 128, 160, 192, 224, 256, 320, :bad ],
      },
      :mpeg_2 => {
        :layer_1 => [
          :free, 32, 48, 56, 64, 80, 96, 112,
          128, 144, 160, 176, 192, 224, 256, :bad ],
        :layer_2 => [
          :free, 8, 16, 24, 32, 40, 48, 56,
          64, 80, 96, 112, 128, 144, 160, :bad ]
      }
    }
    BITRATES[:mpeg_2][:layer_3] = BITRATES[:mpeg_2][:layer_2]
    BITRATES[:mpeg_2_5] = BITRATES[:mpeg_2]

    SAMPLERATES = {
      :mpeg_1 => [ 44100, 48000, 32000, nil ],
      :mpeg_2 => [ 22050, 24000, 16000, nil ],
      :mpeg_2_5 => [ 11025, 12000, 8000, nil ],
    }

    MODES = [ :stereo, :joint_stereo, :dual_channel, :mono ]

    def initialize(bytes)
      version = (bytes[1] >> 3) & 0x03
      layer = (bytes[1] >> 1) & 0x03
      has_crc = bytes[1] & 0x01

      bitrate = (bytes[2] >> 4) & 0x0F
      samplerate = (bytes[2] >> 2) & 0x03
      has_padding = (bytes[2] >> 1) & 0x01

      mode = (bytes[3] >> 6) & 0x03
      mode_extension = (bytes[3] >> 4) & 0x03
      copyright = (bytes[3] >> 3) & 0x01
      original = (bytes[3] >> 2) & 0x01
      emphasis = bytes[3] & 0x03

      @valid = true
      @errorstr = nil

      @version = MPEG_VERSIONS[version]
      if @version.nil?
        @errorstr = "Invalid MPEG version: #{version}"
        @valid = false
        return
      end

      @layer = LAYERS[layer]
      if @layer.nil?
        @errorstr = "Invalid layer: #{layer}"
        @valid = false
        return
      end

      @has_crc = has_crc == 0

      @bitrate = BITRATES[@version][@layer][bitrate]
      if @bitrate.nil? || @bitrate.is_a?(Symbol)
        @errorstr = "Invalid bitrate: #{bitrate}"
        @valid = false
        return 
      end
      @bitrate *= 1000

      @samplerate = SAMPLERATES[@version][samplerate]
      if @samplerate.nil?
        @errorstr = "Invalid samplerate: #{samplerate}"
        @valid = false
        return
      end

      @has_padding = has_padding == 1

      @mode = MODES[mode]
      @mode_extension = mode_extension
      @copyright = copyright == 1
      @original = original == 1
      @emphasis = emphasis

      case @layer
      when :layer_1
        @samples = 384
      when :layer_2
        @samples = 1152
      when :layer_3
        @samples = @version == :mpeg_1 ? 1152 : 576
      end

      raise NotImplementedError, "Not sure how to handle CRC!" if @has_crc

      @frame_size = ((@samples.to_f * @bitrate.to_f / (8 * @samplerate.to_f)) + has_padding).to_i

      if @version == :mpeg_1
        if @mode == :mono
          @side_bytes = 17
        else
          @side_bytes = 32
        end
      else # MPEG 2 / 2.5
        if @mode == :mono
          @side_bytes = 9
        else
          @side_bytes = 17
        end
      end
    end

    def valid?
      @valid
    end
  end
end
