require 'track'

# A track model
module Smoothie
  class User

    include Redis::Objects

    value :username
    value :url
    value :tracks_count

    value :synced_at
    value :favorites_synced_at

    set   :track_ids

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
      track_ids.map{|id|Track.new(id)}.select(&:synced?)
    end


    def synced?
      synced_at && !synced_at.value.nil?
    end

    def set_synced!
      self.synced_at = Time.now
    end

    def favorites_synced?
      favorites_synced_at && !favorites_synced_at.value.nil?
    end

    def set_favorites_synced!
      self.favorites_synced_at = Time.now
    end

  end
end