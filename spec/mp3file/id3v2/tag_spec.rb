require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::Tag do
  it "raises an error if the first 3 bytes don't say \"ID3\"" do
    io = StringIO.new("ID2\x03\x00\x00\x00\x00\x00\x00")
    lambda { Mp3file::ID3v2::Tag.new(io) }.should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end

  it "raises an error if the major version is more than 4 (e.g., no ID3v2.5.0+)" do
    io = StringIO.new("ID3\x05\x00\x00\x00\x00\x00\x00")
    lambda { Mp3file::ID3v2::Tag.new(io) }.should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
  end

  describe "flags:" do
    describe "An ID3v2.2 tag with no set flags:" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00")) }
      its(:version) { should == Mp3file::ID3v2::ID3V2_2_0 }
      its(:unsynchronized) { should == false }
      its(:extended_header) { should == false }
      its(:compression) { should == false }
      its(:experimental) { should == false }
      its(:footer) { should == false }
    end

    describe "An ID3v2.2 tag with the unsync flag set:" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x80\x00\x00\x00\x00")) }
      its(:version) { should == Mp3file::ID3v2::ID3V2_2_0 }
      its(:unsynchronized) { should == true }
      its(:extended_header) { should == false }
      its(:compression) { should == false }
      its(:experimental) { should == false }
      its(:footer) { should == false }
    end

    describe "An ID3v2.2 tag with the compression flag set:" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x40\x00\x00\x00\x00")) }
      its(:version) { should == Mp3file::ID3v2::ID3V2_2_0 }
      its(:unsynchronized) { should == false }
      its(:extended_header) { should == false }
      its(:compression) { should == true }
      its(:experimental) { should == false }
      its(:footer) { should == false }
    end

    describe "An ID3v2.2 tag with an invalid flag set" do
      it "raises an error" do
        lambda { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x20\x00\x00\x00\x00")) }.
          should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
      end
    end

    describe "An ID3v2.3 tag with the extended header flag set:" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x40\x00\x00\x00\x00")) }
      its(:version) { should == Mp3file::ID3v2::ID3V2_3_0 }
      its(:unsynchronized) { should == false }
      its(:extended_header) { should == true }
      its(:compression) { should == false }
      its(:experimental) { should == false }
      its(:footer) { should == false }
    end

    describe "An ID3v2.3 tag with the experimental header flag set:" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x20\x00\x00\x00\x00")) }
      its(:version) { should == Mp3file::ID3v2::ID3V2_3_0 }
      its(:unsynchronized) { should == false }
      its(:extended_header) { should == false }
      its(:compression) { should == false }
      its(:experimental) { should == true }
      its(:footer) { should == false }
    end

    describe "An ID3v2.3 tag with the experimental header flag set:" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x20\x00\x00\x00\x00")) }
      its(:version) { should == Mp3file::ID3v2::ID3V2_3_0 }
      its(:unsynchronized) { should == false }
      its(:extended_header) { should == false }
      its(:compression) { should == false }
      its(:experimental) { should == true }
      its(:footer) { should == false }
    end

    describe "An ID3v2.3 tag with an invalid flag set" do
      it "raises an error" do
        lambda { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x10\x00\x00\x00\x00")) }.
          should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
      end
    end

    describe "An ID3v2.4 tag with the footer header flag set:" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x04\x00\x10\x00\x00\x00\x00")) }
      its(:version) { should == Mp3file::ID3v2::ID3V2_4_0 }
      its(:unsynchronized) { should == false }
      its(:extended_header) { should == false }
      its(:compression) { should == false }
      its(:experimental) { should == false }
      its(:footer) { should == true }
    end
  end

  describe "#version" do
    it "detects ID3v2.2.0" do
      t = Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00"))
      t.version.should == Mp3file::ID3v2::ID3V2_2_0
    end

    it "detects ID3v2.3.0" do
      t = Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x00\x00\x00\x00\x00"))
      t.version.should == Mp3file::ID3v2::ID3V2_3_0
    end

    it "detects ID3v2.4.0" do
      t = Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x04\x00\x00\x00\x00\x00\x00"))
      t.version.should == Mp3file::ID3v2::ID3V2_4_0
    end
  end

  describe "flags for ID3v2.2" do
    describe "An ID3v2.2 tag with no set flags" do
      subject { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00")) }
    end
  end
end
