require 'user'
require 'api_fetch/user_favorites_syncer'
require 'chainable_job/base_job'

module Smoothie
  class PlaylistSyncer < Smoothie::ChainableJob::BaseJob

    @queue = :default

    DEFAULT_LIMIT = 20

    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      
      @user = Smoothie::User.new(@arguments['id'])
      @limit = @arguments['limit'] || DEFAULT_LIMIT
    end


    def ready?
      @user.synced? && @user.favorites_synced?
    end


    def perform
      # Ensure the favorites ids are synced
      wait_for ApiFetch::UserFavoritesSyncer.new('id' => @user.id, 'limit' => @limit, 'force' => @force_execution)

      # Ensure the corresponding tracks are synced
      # wait_for @user.track_ids.map{|track_id| TrackSyncer.new('id' => track_id)}
    end

  end
end