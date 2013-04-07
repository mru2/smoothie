require 'user_syncer'
require 'track'
require 'soundcloud_client'
require 'chainable_job/base_job'

module Smoothie
  class TrackSyncer < Smoothie::ChainableJob::BaseJob

    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      @track = Smoothie::Track.new(@arguments['id'])
    end

    # Is the syncing needed?
    def ready?
      @track.synced?
    end


    # Sync the track
    def perform
      # Core fetching
      soundcloud = Smoothie::SoundcloudClient.new

      # Get the track attributes
      track_data = soundcloud.get_track(@track.id)

      # Save them
      [:uploader_id, :title, :url, :artwork].each do |attribute|
        @track.send(:"#{attribute}=", track_data[attribute])
      end

      # Uploader syncing
      wait_for Smoothie::UserSyncer.new('id' => track_data[:uploader_id])

      # Updating synced_at time
      @track.set_synced!
    end

  end
end