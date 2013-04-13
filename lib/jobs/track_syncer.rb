require 'track'
require 'api_fetch/user_syncer'
require 'api_fetch/track_syncer'
require 'chainable_job/base_job'

module Smoothie
  class TrackSyncer < Smoothie::ChainableJob::BaseJob

    @queue = :api


    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      @track = Smoothie::Track.new(@arguments['id'])
    end


    def ready?
      @track.synced? && @track.uploader && @track.uploader.synced?
    end


    def perform
      # Track syncing
      wait_for ApiFetch::TrackSyncer.new('id' => @track.id)

      # Uploader syncing
      wait_for ApiFetch::UserSyncer.new('id' => @track.uploader_id.value)
    end

  end
end

