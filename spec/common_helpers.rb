require "pathname"
require "stringio"
require "rspec/its"

module CommonHelpers
  def fixture_file(filename)
    Pathname.new(__FILE__).dirname.expand_path.join('files', filename)
  end

  def create_io(nums)
    StringIO.new(nums.map { |n| n.chr }.join)
  end
end
