require File.dirname(__FILE__) + '/../../lib/mp3file'
require File.dirname(__FILE__) + '/../common_helpers'

include CommonHelpers

describe Mp3file::XingHeader do
  it 'raises an error if the first 4 bytes don\'t say "Xing"' do
    io = StringIO.new("Ping\x00\x00\x00\x00")
    lambda { Mp3file::XingHeader.new(io) }.should(raise_error(Mp3file::InvalidXingHeaderError))
  end

  it 'raises an error if the next int is more than 15' do
    io = StringIO.new("Xing\x00\x00\x00\x10")
    lambda { Mp3file::XingHeader.new(io) }.should(raise_error(Mp3file::InvalidXingHeaderError))
  end

  describe "with no parts" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x00")) }
    its(:frames) { should == nil }
    its(:bytes) { should == nil }
    its(:toc) { should == nil }
    its(:quality) { should == nil }
  end

  describe "with only a frame count" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x01\x00\x00\x14\xFA")) }
    its(:frames) { should == 5370 }
    its(:bytes) { should == nil }
    its(:toc) { should == nil }
    its(:quality) { should == nil }
  end

  describe "with only a byte count" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x02\x00\x00\x14\xFA")) }
    its(:frames) { should == nil }
    its(:bytes) { should == 5370 }
    its(:toc) { should == nil }
    its(:quality) { should == nil }
  end

  describe "with only a TOC" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x04" + ("\x00" * 100))) }
    its(:frames) { should == nil }
    its(:bytes) { should == nil }
    its(:toc) { should == [ 0 ] * 100 }
    its(:quality) { should == nil }
  end

  describe "with only a quality" do
    subject { Mp3file::XingHeader.new(StringIO.new("Xing\x00\x00\x00\x08\x00\x00\x00\x55")) }
    its(:frames) { should == nil }
    its(:bytes) { should == nil }
    its(:toc) { should == nil }
    its(:quality) { should == 85 }
  end

  describe "with all four" do
    subject do
      str = [ 
        'Xing', # ID
        "\x00\x00\x00\x0F", # Which fields are present
        "\x00\x4B\xF4\x80", # The frame count
        "\x00\x1C\x7B\xB0", # The byte count
        "\x00" * 100,       # The TOC
        "\x00\x00\x00\x55",  # The quality
      ].join('')
      Mp3file::XingHeader.new(StringIO.new(str))
    end

    its(:frames) { should == 4977792 }
    its(:bytes) { should == 1866672 }
    its(:toc) { should == [ 0 ] * 100 }
    its(:quality) { should == 85 }
  end
end
