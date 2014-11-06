require 'pathname'

require 'rubygems'
require 'bindata'

module Empythree
  class MP3FileError < StandardError; end
end

require 'empythree/mp3_file'
require 'empythree/mp3_header'
require 'empythree/xing_header'
require 'empythree/id3v1_tag'
require 'empythree/id3v2'
