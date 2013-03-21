# A track model
module Smoothie
  class User

    include Redis::Objects

    value :username
    value :url

    value :synced_at

    set :track_ids

    def initialize(uid)
      @uid = uid
    end

    def id
      @uid
    end

    def tracks
      track_ids.map{|id|Track.new(id)}
    end

  end
end