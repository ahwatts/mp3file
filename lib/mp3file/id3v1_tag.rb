module Mp3file
  class InvalidID3v1TagError < Mp3fileError; end

  class ID3v1Tag
    attr_accessor(:title, :artist, :album, :year, :comment, :track, :genre)

    class ID3v1TagFormat < BinData::Record
      string(:tag_id, :length => 3, :check_value => lambda { value == 'TAG' })
      string(:title, :length => 30)
      string(:artist, :length => 30)
      string(:album, :length => 30)
      string(:year, :length => 4)
      string(:comment, :length => 30)
      uint8(:genre_id)
    end

    def initialize(io)
      tag = nil
      begin
        ID3v1TagFormat.read(io)
      rescue BinData::ValidityError => ve
        raise InvalidID3v1TagError, ve.message
      end
    end
  end
end
