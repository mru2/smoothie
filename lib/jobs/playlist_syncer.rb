require 'user'
require 'api_fetch/user_syncer'
require 'api_fetch/user_favorites_syncer'
require 'track_syncer'
require 'chainable_job/base_job'

module Smoothie
  class PlaylistSyncer < Smoothie::ChainableJob::BaseJob

    @queue = :default

    DEFAULT_LIMIT = 20

    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      
      @user = Smoothie::User.new(@arguments['id'])
    end


    def ready?
      @user.synced? && @user.favorites_synced? && @user.tracks.map(&:synced?).reduce(&:&)
    end


    def perform
      # Ensure the user is synced
      wait_for ApiFetch::UserSyncer.new('id' => @user.id)

      # Ensure the favorites ids are synced
      wait_for ApiFetch::UserFavoritesSyncer.new('id' => @user.id, 'limit' => limit)

      # Ensure the corresponding tracks are synced
      wait_for @user.track_ids.map{|track_id| TrackSyncer.new('id' => track_id)}
    end

    private 

    # How many tracks should be fetched
    def limit

      if @arguments['limit']
        # All : get the user tracks count
        if @arguments['limit'] == 'all'
          @user.tracks_count.value.to_i
        else
          @arguments['limit'].to_i
        end

      else
        DEFAULT_LIMIT
      end
    end

  end
end