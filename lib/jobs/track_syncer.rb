require 'user_syncer'
require 'track'
require 'soundcloud_client'

module Smoothie
  class TrackSyncer

    def initialize(id)
      @track = Smoothie::Track.new(id)
    end

    # Run the syncing if need be, returns the track
    def run
      perform! unless syncing_done?
      return @track
    end

    private

    # Sync the track
    def perform!

      # Core fetching
      soundcloud = Smoothie::SoundcloudClient.new

      # Get the track attributes
      track_data = soundcloud.get_track(@track.id)

      # Save them
      [:uploader_id, :title, :url, :artwork].each do |attribute|
        @track.send(:"#{attribute}=", track_data[attribute])
      end

      # Uploader syncing
      Smoothie::UserSyncer.new(track_data[:uploader_id]).run

      # Updating synced_at time
      @track.synced_at = Time.now

    end

    # Check if the track is supposed to be synced
    # In this case : no expiration
    def syncing_done?
      ! @track.synced_at.nil?
    end

  end
end