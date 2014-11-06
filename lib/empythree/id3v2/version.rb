module Mp3file::ID3v2
  class Version
    include Comparable

    attr_reader(:vbig, :vmaj, :vmin)

    def initialize(vmaj, vmin, vbig = 2)
      @vbig = vbig.to_i
      @vmaj = vmaj.to_i
      @vmin = vmin.to_i
    end

    def <=>(other)
      c = vbig <=> other.vbig
      return c if c != 0

      c = vmaj <=> other.vmaj
      return c if c != 0

      vmin <=> other.vmin
    end

    def to_s
      "ID3v%d.%d.%d" % [ vbig, vmaj, vmin ]
    end

    def to_byte_string
      [ vmaj, vmin ].pack("cc")
    end

    def inspect
      "<%p vbig = %p vmaj = %p vmin = %p>" %
        [ self.class, @vbig, @vmaj, @vmin ]
    end
  end

  ID3V2_4_0 = Version.new(4, 0)
  ID3V2_3_0 = Version.new(3, 0)
  ID3V2_2_0 = Version.new(2, 0)
end
