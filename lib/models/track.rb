# Handle persistence in neo4j
# Also querying
module Smoothie

  class Track

    attr_reader :id

    def initialize(id)
      @id = id
    end

    def set_attrs(artist, title, likers_count)
      @artist = artist
      @title = title
      @likers_count = likers_count
    end

    def add_liker(user_id)

    end

    def likers
    end   

  end

end