module Mp3file::ID3v2
  module BitPaddedInt
    def self.unpad_number(num, bits = 7)
      field = 2**bits - 1
      rv = 0
      0.upto(3) do |i|
        rv += (num & field) >> (i*(8-bits))
        field = field << 8
      end
      rv
    end

    def self.pad_number(num, bits = 7)
      field = 2**bits - 1
      num2 = num
      rv = 0
      0.upto(3) do |i|
        rv += (num2 & field) << (i*8)
        num2 = num2 >> bits
      end
      rv
    end
  end
end
