require 'user'

# A track model
module Smoothie
  class Track

    EXPIRATION = 604800 # 1 week
    FAVORITES_EXPIRATION = 604800 # 1 week

    include Redis::Objects

    value :users_count
    value :synced_at
    value :favoriters_synced_at

    set   :user_ids

    # We want to guarantee that the uid is present
    def self.new(*args)
      (args == [nil]) ? nil : super
    end


    def initialize(uid)
      return nil unless uid

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
      track_data = soundcloud.get_track(id)

      # Save them
      self.users_count = track_data.favoritings_count

      # Updated the synced_at time
      self.synced_at = Time.now
    end
    

    def favoriters_synced?(expiration = nil)
      # Not synced ?
      return false if favoriters_synced_at.value.nil?

      # Expired ?
      !( expiration && ( Time.parse(favoriters_synced_at.value) < (Time.now - expiration) ) )
    end


    def sync_favoriters!(opts = {})
      limit     = opts[:limit]     || self.users_count.value.to_i
      overwrite = opts[:overwrite] || false

      soundcloud = Smoothie::SoundcloudClient.new
      favoriters_ids = soundcloud.get_track_favoriters(id, limit)

      if overwrite
        user_ids.del
      end

      user_ids.add favoriters_ids

      self.favoriters_synced_at = Time.now

      favoriters_ids
    end

  end
end