require File.dirname(__FILE__) + '/../../../lib/empythree'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Empythree::ID3v2::Version do
  describe Empythree::ID3v2::ID3V2_2_0 do
    subject { Empythree::ID3v2::ID3V2_2_0 }
    its(:vbig) { should == 2 }
    its(:vmaj) { should == 2 }
    its(:vmin) { should == 0 }
    its(:to_s) { should == 'ID3v2.2.0' }
    its(:to_byte_string) { should == "\x02\x00" }
  end

  describe Empythree::ID3v2::ID3V2_3_0 do
    subject { Empythree::ID3v2::ID3V2_3_0 }
    its(:vbig) { should == 2 }
    its(:vmaj) { should == 3 }
    its(:vmin) { should == 0 }
    its(:to_s) { should == 'ID3v2.3.0' }
    its(:to_byte_string) { should == "\x03\x00" }
  end

  describe Empythree::ID3v2::ID3V2_4_0 do
    subject { Empythree::ID3v2::ID3V2_4_0 }
    its(:vbig) { should == 2 }
    its(:vmaj) { should == 4 }
    its(:vmin) { should == 0 }
    its(:to_s) { should == 'ID3v2.4.0' }
    its(:to_byte_string) { should == "\x04\x00" }
  end

  describe "#<=>" do
    it("should recognize that ID3v2.2 < ID3v2.3") do
      (Empythree::ID3v2::ID3V2_2_0 <=> Empythree::ID3v2::ID3V2_3_0).should == -1
    end

    it("should recognize that ID3v2.4 > ID3v2.2") do
      (Empythree::ID3v2::ID3V2_4_0 <=> Empythree::ID3v2::ID3V2_2_0).should == 1
    end

    it("should recognize that ID3v2.3 == ID3v2.3") do
      (Empythree::ID3v2::ID3V2_3_0 <=> Empythree::ID3v2::ID3V2_3_0).should == 0
    end
  end

  describe "#new" do
    subject { Empythree::ID3v2::Version.new(3, 1) }
    its(:vbig) { should == 2 }
    its(:vmaj) { should == 3 }
    its(:vmin) { should == 1 }
    its(:to_s) { should == 'ID3v2.3.1' }
    its(:to_byte_string) { should == "\x03\x01" }
  end
end
