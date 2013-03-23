module Mp3file
  class InvalidID3v1TagError < Mp3fileError; end

  class ID3v1Tag
    attr_accessor(:title, :artist, :album, :year, :comment, :track, :genre_id, :genre)

    class ID3v1TagFormat < BinData::Record
      string(:tag_id, :length => 3, :check_value => lambda { value == 'TAG' })
      string(:title, :length => 30)
      string(:artist, :length => 30)
      string(:album, :length => 30)
      string(:year, :length => 4)
      string(:comment, :length => 30)
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

    def initialize(io)
      @tag = nil
      begin
        @tag = ID3v1TagFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidID3v1TagError, ve.message
      end

      @title = @tag.title.split("\x00").first
      @artist = @tag.artist.split("\x00").first
      @album = @tag.album.split("\x00").first
      @year = @tag.year
      split_comment = @tag.comment.split("\x00").reject { |s| s == '' }
      @comment = split_comment.first
      if split_comment.size > 1
        @track = split_comment.last.bytes.first
      end
      @genre_id = @tag.genre_id
      @genre = GENRES[@tag.genre_id]
    end
  end
end
