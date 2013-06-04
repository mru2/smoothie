require 'track'
require 'api_fetch/track_syncer'
require 'soundcloud_client'
require 'chainable_job/base_job'

module Smoothie
  module ApiFetch
    class TrackFavoritersSyncer < Smoothie::ChainableJob::BaseJob

      @queue = :api


      def initialize(opts = {})
        super

        throw "id must be defined" unless @arguments['id']
        throw "limit must be defined" unless @arguments['limit']

        @limit = @arguments['limit']
        @track = Smoothie::Track.new(@arguments['id'])
      end


      def ready?
        @track.favoriters_synced?
      end


      def perform
        # Ensure the user is synced
        wait_for ApiFetch::TrackSyncer.new('id' => @track.id)

        soundcloud = Smoothie::SoundcloudClient.new

        # Get the favorites ids
        favoriter_ids = soundcloud.get_track_favoriters(@track.id, @limit)

        # Add them to the user favorites (clear the old ones if all are fetched)
        @track.user_ids.del if @limit == 'all'
        @track.user_ids << favorite_ids

        # Updated the synced_at time
        @track.set_favoriters_synced!
      end

    end
  end
end