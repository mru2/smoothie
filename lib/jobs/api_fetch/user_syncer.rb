require 'user'
require 'soundcloud_client'
require 'chainable_job/base_job'

module Smoothie
  module ApiFetch
    class UserSyncer < Smoothie::ChainableJob::BaseJob

      @queue = :api


      def initialize(opts = {})
        super

        throw "id must be defined" unless @arguments['id']

        @user = Smoothie::User.new(@arguments['id'])
      end


      def ready?
        @user.synced?
      end


      def perform
        soundcloud = Smoothie::SoundcloudClient.new

        # Get the user attributes
        user_data = soundcloud.get_user(@user.id)

        # Save them
        [:username, :url, :tracks_count].each do |attribute|
          @user.send(:"#{attribute}=", user_data[attribute])
        end

        # Updated the synced_at time
        @user.set_synced!
      end

    end
  end
end