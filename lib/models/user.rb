require 'track'
require 'soundcloud_client'

# A track model
module Smoothie
  class User

    EXPIRATION = 604800 # 1 week
    FAVORITES_EXPIRATION = 604800 # 1 week
    TRACKS_GRAPH_EXPIRATION = 604800 # 1 week

    include Redis::Objects

    value :tracks_count

    value :synced_at
    value :favorites_synced_at
    value :track_graph_synced_at

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


    def synced?(expiration = nil)
      # Not synced ?
      return false if synced_at.value.nil?

      # Expired ?
      !( expiration && ( Time.parse(synced_at.value) < (Time.now - expiration) ) )
    end


    def sync!
      soundcloud = Smoothie::SoundcloudClient.new

      # Get the user attributes
      user_data = soundcloud.get_user(id)

      # Save them
      self.tracks_count = user_data.public_favorites_count

      # Updated the synced_at time
      self.synced_at = Time.now
    end
    


    def favorites_synced?(expiration = nil)
      # Not synced ?
      return false if favorites_synced_at.value.nil?

      # Expired ?
      !( expiration && ( Time.parse(favorites_synced_at.value) < (Time.now - expiration) ) )
    end


    def sync_favorites!(opts = {})
      limit     = opts[:limit]     || self.tracks_count.value.to_i
      overwrite = opts[:overwrite] || false

      soundcloud = Smoothie::SoundcloudClient.new
      favorites_ids = soundcloud.get_user_favorites(id, limit)

      if overwrite
        track_ids.del
      end

      track_ids.add favorites_ids

      self.favorites_synced_at = Time.now

      favorites_ids
    end


    def track_graph_synced?(expiration = nil)
      # Not synced ?
      return false if track_graph_synced_at.value.nil?

      # Expired ?
      !( expiration && ( Time.parse(track_graph_synced_at.value) < (Time.now - expiration) ) )
    end

  end
end