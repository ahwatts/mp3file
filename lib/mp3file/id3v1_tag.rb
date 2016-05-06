module Mp3file
  class InvalidID3v1TagError < Mp3fileError; end

  class ID3v1Tag
    attr_accessor(:title, :artist, :album, :year, :comment, :track, :genre_id, :genre)

    class ID3v1TagFormat < BinData::Record
      string(:tag_id, read_length: 3, asserted_value: "TAG")
      string(:title,   length: 30, trim_padding: true)
      string(:artist,  length: 30, trim_padding: true)
      string(:album,   length: 30, trim_padding: true)
      string(:year,    length:  4, trim_padding: true)
      string(:comment, length: 30)
      uint8(:genre_id)
    end

    # First group is the original spec, the second are Winamp extensions.
    GENRES = 
      %w{ Blues Classic\ Rock Country Dance Disco Funk Grunge Hip-Hop Jazz 
        Metal New\ Age Oldies Other Pop R&B Rap Reggae Rock Techno Industrial 
        Alternative Ska Death\ Metal Pranks Soundtrack Euro-Techno Ambient Trip-Hop 
        Vocal Jazz+Funk Fusion Trance Classical Instrumental Acid House Game 
        Sound\ Clip Gospel Noise AlternRock Bass Soul Punk Space Meditative 
        Instrumental\ Pop Instrumental\ Rock Ethnic Gothic Darkwave Techno-Industrial 
        Electronic Pop-Folk Eurodance Dream Southern\ Rock Comedy Cult Gangsta 
        Top\ 40 Christian\ Rap Pop/Funk Jungle Native\ American Cabaret New\ Wave 
        Psychadelic Rave Showtunes Trailer Lo-Fi Tribal Acid\ Punk Acid\ Jazz Polka 
        Retro Musical Rock\ &\ Roll Hard\ Rock 

        Folk Folk-Rock National\ Folk Swing 
        Fast\ Fusion Bebob Latin Revival Celtic Bluegrass Avantgarde Gothic\ Rock 
        Progressive\ Rock Psychedelic\ Rock Symphonic\ Rock Slow\ Rock Big\ Band 
        Chorus Easy\ Listening Acoustic Humour Speech Chanson Opera Chamber\ Music 
        Sonata Symphony Booty\ Bass Primus Porn\ Groove Satire Slow\ Jam Club Tango 
        Samba Folklore Ballad Power\ Ballad Rhythmic\ Soul Freestyle Duet Punk\ Rock 
        Drum\ Solo A\ capella Euro-House Dance\ Hall }

    def self.parse(io)
      tag_data = nil

      begin
        tag_data = ID3v1TagFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidID3v1TagError, ve.message
      end

      if tag_data.nil?
        nil
      else
        new.tap { |rv| rv.load_format(tag_data) }
      end
    end

    def load_format(tag_data)
      @title = tag_data.title
      @artist = tag_data.artist
      @album = tag_data.album
      @year = tag_data.year
      split_comment = tag_data.comment.split("\x00").reject { |s| s == '' }
      @comment = split_comment.first || ""
      if split_comment.size > 1
        @track = split_comment.last.bytes.first
      end
      @genre_id = tag_data.genre_id
      @genre = GENRES[tag_data.genre_id]
    end

    def initialize
      @title = @artist = @album = @year = @comment = @track = @genre_id = @genre = nil
    end
  end
end
