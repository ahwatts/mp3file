require 'pathname'

require 'rubygems'
require 'bindata'

module Mp3file
  class Mp3fileError < StandardError; end
end

require 'mp3file/mp3_file'
require 'mp3file/mp3_header'
require 'mp3file/xing_header'
require 'mp3file/id3v1_tag'
require 'mp3file/id3v2'
