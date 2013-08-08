# Fetches a users's track graph (favorite tracks of users who favorited the same tracks as the first one)
# Need to sync the tracks / users until the last level, to get their favorites / favoriters count
require 'chainable_job/base_job'
require 'playlist_syncer'
require 'api_fetch/track_favoriters_syncer'
require 'api_fetch/user_favorites_syncer'
  
module Smoothie
  class TrackGraphSyncer < Smoothie::ChainableJob::BaseJob

    @queue = :default

    DEFAULT_LIMIT = 10

    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      
      @user   = Smoothie::User.new(@arguments['id'])
    end

    def ready?
      @user.tracks_graph_up_to_date?
    end


    # Naive implementation, to make recursive when a little more mature
    # Complexity : NxLxL -- N : size of user playlist -- L : limit size
    def perform
      # Ensure the user's playlist is synced
      wait_for Smoothie::PlaylistSyncer.new('id' => @user.id)


      # Sync the playlist details (for the users count, AND their favoriters ids)
      user_tracks_ids = @user.track_ids.members # N

      wait_for user_tracks_ids.map{|track_id|
        ApiFetch::TrackFavoritersSyncer.new('id' => track_id)
      }


      # Sync the other users details (their favorite count and ids)
      other_favoriters_ids = user_tracks_ids.map{|track_id| Track.new(track_id).user_ids.members}.flatten.uniq

      wait_for other_favoriters_ids.map{|user_id|
        ApiFetch::UserFavoritesSyncer.new('id' => user_id)
      }


      # Sync the deep tracks ids (for their favoriters count)
      deep_track_ids = other_favoriters_ids.map{|user_id|User.new(user_id).track_ids.members}.flatten.uniq

      wait_for deep_track_ids.map{|track_id|
        ApiFetch::TrackSyncer.new(track_id)
      }

      @user.set_track_graph_synced!

    end
  end
end
