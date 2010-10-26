require 'pathname'

module CommonHelpers
  def fixture_file(filename)
    Pathname.new(__FILE__).dirname.expand_path.join('files', filename)
  end
end
