module Mp3file
  module ID3v2
    class InvalidID3v2TagError < Mp3fileError; end
  end
end

require 'mp3file/id3v2/bit_padded_int'
require 'mp3file/id3v2/version'
require 'mp3file/id3v2/header'
