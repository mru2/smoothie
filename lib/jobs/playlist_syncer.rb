require 'user'
require 'api_fetch/user_favorites_syncer'
require 'chainable_job/base_job'

module Smoothie
  class PlaylistSyncer < Smoothie::ChainableJob::BaseJob

    @queue = :api

    EXPIRATION = 86400 # 1 day


    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      
      @user = Smoothie::User.new(@arguments['id'])
    end


    def ready?
      @user.favorites_synced?(EXPIRATION)
    end


    def perform

      # Sync the user (to get the new track limit)
      @user.sync!

      # Sync its favorites
      @user.sync_favorites!(:overwrite => true)

    end

  end
end