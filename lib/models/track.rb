# A track model
module Smoothie
  class Track

    include Redis::Objects

    value :title
    value :artwork
    value :url
    value :uploader_id

    value :synced_at

    set :user_ids

    def initialize(uid)
      @uid = uid
    end

    def id
      @uid
    end

  end
end