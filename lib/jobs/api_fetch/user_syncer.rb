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
      end


      def ready?
        user.up_to_date?
      end


      def perform
        soundcloud = Smoothie::SoundcloudClient.new

        # Get the user attributes
        user_data = soundcloud.get_user(user.id)

        # Save them
        [:tracks_count].each do |attribute|
          user.send(:"#{attribute}=", user_data[attribute])
        end

        # Updated the synced_at time
        user.set_synced!
      end

      private

      def user
        @user ||= Smoothie::User.new(@arguments['id'])
      end

    end
  end
end