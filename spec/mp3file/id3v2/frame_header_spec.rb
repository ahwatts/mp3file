require File.dirname(__FILE__) + '/../../../lib/mp3file'
require File.dirname(__FILE__) + '/../../common_helpers'

include CommonHelpers

describe Mp3file::ID3v2::FrameHeader do
  context "with ID3v2.2 tags" do
    let(:tag) { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x02\x00\x00\x00\x00\x00\x00")) }

    describe("A 15-byte long TT2 frame header.") do
      subject { Mp3file::ID3v2::FrameHeader.new(StringIO.new("TT2\x00\x00\x0f"), tag) }
      its(:frame_id) { should == 'TT2' }
      its(:size) { should == 15 }
      its(:preserve_on_altered_tag) { should == false }
      its(:preserve_on_altered_file) { should == false }
      its(:read_only) { should == false }
      its(:compressed) { should == false }
      its(:encrypted) { should == false }
      its(:encryption_type) { should be_nil }
      its(:group) { should be_nil }
      its(:unsynchronized) { should == false }
      its(:data_length) { should == 0 }
    end
  end
  
  context "with ID3v2.3 tags" do
    let(:tag) { Mp3file::ID3v2::Tag.new(StringIO.new("ID3\x03\x00\x00\x00\x00\x00\x00")) }

    describe("A header with invalid flag bits set") do
      it("Should raise an error") do
        io = StringIO.new("TIT2\x00\x00\x00\x09\x01\x00")
        lambda { Mp3file::ID3v2::FrameHeader.new(io, tag) }.
          should(raise_error(Mp3file::ID3v2::InvalidID3v2TagError))
      end
    end
    
    describe("A 9-byte TIT2 frame header.") do
      subject { Mp3file::ID3v2::FrameHeader.new(StringIO.new("TIT2\x00\x00\x00\x09\x00\x00"), tag) }
      its(:frame_id) { should == 'TIT2' }
      its(:size) { should == 9 }
      its(:preserve_on_altered_tag) { should == false }
      its(:preserve_on_altered_file) { should == false }
      its(:read_only) { should == false }
      its(:compressed) { should == false }
      its(:encrypted) { should == false }
      its(:encryption_type) { should be_nil }
      its(:group) { should be_nil }
      its(:unsynchronized) { should == false }
      its(:data_length) { should == 0 }
    end

    describe("A TIT2 header with all of its flags set") do
      subject { Mp3file::ID3v2::FrameHeader.new(StringIO.new("TIT2\x00\x00\x00\x09\x00\x00"), tag) }
      its(:frame_id) { should == 'TIT2' }
      its(:size) { should == 9 }
      its(:preserve_on_altered_tag) { should == false }
      its(:preserve_on_altered_file) { should == false }
      its(:read_only) { should == false }
      its(:compressed) { should == false }
      its(:encrypted) { should == false }
      its(:encryption_type) { should be_nil }
      its(:group) { should be_nil }
      its(:unsynchronized) { should == false }
      its(:data_length) { should == 0 }
    end
  end
end
