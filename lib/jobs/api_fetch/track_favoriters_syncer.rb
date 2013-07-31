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

        @track = Smoothie::Track.new(@arguments['id'])
      end


      def ready?
        @track.favoriters_up_to_date?
      end


      def perform
        # Ensure the track is synced
        wait_for ApiFetch::TrackSyncer.new('id' => @track.id)

        soundcloud = Smoothie::SoundcloudClient.new

        # Get the favoriters ids
        limit = @track.users_count.value.to_i
        favoriter_ids = soundcloud.get_track_favoriters(@track.id, limit)

        # Save them
        unless favoriter_ids.empty?
          @track.user_ids.del
          @track.user_ids << favoriter_ids
        end

        # Updated the synced_at time
        @track.set_favoriters_synced!
      end

    end
  end
end