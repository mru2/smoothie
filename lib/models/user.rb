# A track model
module Smoothie
  class User

    include Redis::Objects

    value :username
    value :url

    value :synced_at

    set :track_ids

    # We want to guarantee that the uid is present
    def self.new(*args)
      (args == [nil]) ? nil : super
    end

    def initialize(uid)
      @uid = uid
    end

    def id
      @uid
    end

    def tracks
      track_ids.map{|id|Track.new(id)}
    end

    def synced?
      synced_at && !synced_at.value.nil?
    end

  end
end