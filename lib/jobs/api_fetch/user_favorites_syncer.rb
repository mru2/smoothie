require 'user'
require 'soundcloud_client'
require 'chainable_job/base_job'

module Smoothie
  module ApiFetch
    class UserFavoritesSyncer < Smoothie::ChainableJob::BaseJob

      @queue = :api


      def initialize(opts = {})
        super

        throw "id must be defined" unless @arguments['id']
        throw "limit must be defined" unless @arguments['limit']

        @limit = @arguments['limit']
        @user = Smoothie::User.new(@arguments['id'])
      end


      def ready?
        @user.favorites_synced?
      end


      def perform
        soundcloud = Smoothie::SoundcloudClient.new

        # Get the favorites ids
        favorite_ids = soundcloud.get_user_favorites(@user.id, @limit)

        # Add them to the user favorites
        @user.track_ids << favorite_ids

        # Updated the synced_at time
        @user.set_favorites_synced!
      end

    end
  end
end