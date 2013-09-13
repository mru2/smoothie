require 'base_job'
require 'user'

module Smoothie
  class PlaylistSyncer < Smoothie::BaseJob

    include Resque::Plugins::UniqueJob

    @queue = :api

    EXPIRATION = 36000 # 10 hours


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