module Mp3file
  class InvalidID3v1HeaderError < Mp3fileError; end

  class ID3v1Header
    attr_accessor(:title, :artist, :album, :year, :comment, :track, :genre)

    class ID3v1HeaderFormat < BinData::Record
      string(:tag_id, :length => 3, :check_value => lambda { value == 'TAG' })
      string(:title, :length => 30)
      string(:artist, :length => 30)
      string(:album, :length => 30)
      string(:year, :length => 4)
      string(:comment, :length => 30)
      uint8(:genre_id)
    end
  end
end
