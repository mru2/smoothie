require 'user'
require 'soundcloud_client'
require 'track_syncer'
require 'chainable_job'

module Smoothie
  class UserFavoritesSyncer < ChainableJob

    def initialize(opts)
      super

      throw "argument 'id' must be defined" unless id = opts["id"]
      @limit = opts["limit"] || 20

      @user = Smoothie::User.new(id)
    end

    # Does the syncing need to be done
    def ready?
      @user.favorites_synced?
    end

    # Sync the user
    def perform
      soundcloud = Smoothie::SoundcloudClient.new

      # Ensure the user is synced
      wait_for UserSyncer.new("id" => @user.id)

      # Get the favorites
      favorite_ids = soundcloud.get_user_favorites(@user.id, @limit)

      # Ensure they are synced
      wait_for favorite_ids.map{|track_id| TrackSyncer.new("id" => track_id)}

      # Add them to the user favorites
      @user.track_ids << favorite_ids

      # Updated the synced_at time
      @user.set_favorites_synced!
    end

  end
end