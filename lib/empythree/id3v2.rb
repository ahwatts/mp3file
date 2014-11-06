module Empythree
  module ID3v2
    class InvalidID3v2TagError < MP3FileError; end
  end
end

require 'empythree/id3v2/bit_padded_int'
require 'empythree/id3v2/version'
require 'empythree/id3v2/header'
require 'empythree/id3v2/tag'
require 'empythree/id3v2/frame_header'
require 'empythree/id3v2/text_frame'
