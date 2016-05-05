# Mp3file

This is a pure-Ruby MP3 metadata extractor. We use it to identify the
bitrate and duration of songs that people upload to [http://www.reverbnation.com].

It handles a bunch of things:
* ID3v1 tags
* ID3v2 tags (although it doesn't actually parse the frames)
* VBR files (with Xing headers)
* Multiple ID3v2 tags (because these exist in the wild)

Don't think of this as an example of good code. This is some of the
most terrible, ugly, brutally hacky code I think I've ever written. I
apologize to anyone who looks at it.

[![Build Status](https://travis-ci.org/ahwatts/mp3file.svg?branch=master)](https://travis-ci.org/ahwatts/mp3file)
