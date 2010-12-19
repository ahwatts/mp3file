require 'pathname'

require 'rubygems'
require 'bindata'

class Mp3fileError < StandardError; end

require 'mp3file/bit_padded_int'
require 'mp3file/mp3_file'
require 'mp3file/mp3_header'
require 'mp3file/xing_header'
require 'mp3file/id3v1_header'
