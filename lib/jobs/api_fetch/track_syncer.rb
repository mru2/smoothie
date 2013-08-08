require 'track'
require 'soundcloud_client'
require 'chainable_job/base_job'

module Smoothie
  module ApiFetch
    class TrackSyncer < Smoothie::ChainableJob::BaseJob

      @queue = :api


      def initialize(opts = {})
        super

        throw "id must be defined" unless @arguments['id']
        @track = Smoothie::Track.new(@arguments['id'])
      end


      def ready?
        @track.up_to_date?
      end


      def perform
        # Core fetching
        soundcloud = Smoothie::SoundcloudClient.new

        # Get the track attributes
        track_data = soundcloud.get_track(@track.id)

        # Save them
        [:users_count].each do |attribute|
          @track.send(:"#{attribute}=", track_data[attribute])
        end

        # Updating synced_at time
        @track.set_synced!
      end

    end
  end
end