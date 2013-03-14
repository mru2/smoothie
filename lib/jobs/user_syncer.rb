require 'user'
require 'soundcloud_client'

module Smoothie
  class UserSyncer

    include Celluloid

    def initialize(id)
      @user = Smoothie::User.new(id)
    end

    # Run the syncing if need be, returns the user
    def run
      perform! unless syncing_done?

      return @user
    end

    private

    # Sync the user
    def perform!
      soundcloud = Smoothie::SoundcloudClient.new

      # Get the user attributes
      user_data = soundcloud.get_user(@user.id)

      # Save them
      [:username, :url].each do |attribute|
        @user.send(:"#{attribute}=", user_data[attribute])
      end

      # Updated the synced_at time
      @user.synced_at = Time.now
    end

    # Check if the track is supposed to be synced
    # In this case : no expiration
    def syncing_done?
      ! @user.synced_at.nil?
    end

  end
end