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
      its(:group) { should == false }
      its(:unsynchronized) { should == false }
      its(:data_length) { should == 0 }
    end
  end
end
