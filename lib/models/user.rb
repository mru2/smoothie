require 'track'

# A track model
module Smoothie
  class User

    EXPIRATION = 86400 # 1 day
    FAVORITES_EXPIRATION = 86400 # 1 day
    TRACKS_GRAPH_EXPIRATION = 86400 # 1 day

    include Redis::Objects

    value :tracks_count

    value :synced_at
    value :favorites_synced_at
    value :tracks_graph_synced_at

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


    def synced?
      synced_at && !synced_at.value.nil?
    end

    def up_to_date?
      synced? && (Time.parse(synced_at.value) > (Time.now - EXPIRATION))
    end

    def set_synced!
      self.synced_at = Time.now
    end


    def favorites_synced?
      favorites_synced_at && !favorites_synced_at.value.nil?
    end

    def favorites_up_to_date?
      favorites_synced? && (Time.parse(favorites_synced_at.value) > (Time.now - FAVORITES_EXPIRATION))
    end

    def set_favorites_synced!
      self.favorites_synced_at = Time.now
    end


    def tracks_graph_synced?
      tracks_graph_synced_at && !tracks_graph_synced_at.value.nil?
    end

    def tracks_graph_up_to_date?
      tracks_graph_synced? && (Time.parse(tracks_graph_synced_at.value) > (Time.now - TRACKS_GRAPH_EXPIRATION))
    end

    def set_track_graph_synced!
      self.tracks_graph_synced_at = Time.now
    end

  end
end