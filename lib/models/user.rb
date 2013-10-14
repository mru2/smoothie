require 'track'
require 'soundcloud_client'
require 'recommender_engine'

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

    set         :track_ids
    sorted_set  :recommendations
    value       :recommendations_computed_at

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

      begin

        # Get the user attributes
        user_data = soundcloud.get_user(id)

        # Save them
        self.tracks_count = user_data.public_favorites_count

        # Updated the synced_at time
        self.synced_at = Time.now

      rescue Soundcloud::ResponseError => e

      end

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

      begin

        favorites_ids = soundcloud.get_user_favorites(id, limit)

        if overwrite
          track_ids.del
        end

        track_ids.add favorites_ids unless favorites_ids.empty?

        self.favorites_synced_at = Time.now

      rescue Soundcloud::ResponseError => e

        favorites_ids = []

      end

      favorites_ids
    end


    def track_graph_synced?(expiration = nil)
      # Not synced ?
      return false if track_graph_synced_at.value.nil?

      # Expired ?
      !( expiration && ( Time.parse(track_graph_synced_at.value) < (Time.now - expiration) ) )
    end


    # Compute the recommendations
    def compute_recommendations!
      recommender = Smoothie::RecommenderEngine::Engine.new(self)
      recommended_tracks = recommender.top_tracks(1000)

      self.recommendations.del
      recommended_tracks.each do |track|
        self.recommendations.add track[:id], track[:score]
      end

      self.recommendations_computed_at = Time.now

      recommended_tracks
    end

    def recommendations_computed?(expiration = nil)
      # Not synced ?
      return false if recommendations_computed_at.value.nil?

      # Expired ?
      !( expiration && ( Time.parse(recommendations_computed_at.value) < (Time.now - expiration) ) )
    end


  end
end