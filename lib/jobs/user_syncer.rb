require 'user'
require 'soundcloud_client'
require 'chainable_job'

module Smoothie
  class UserSyncer < ChainableJob

    def initialize(opts)
      super

      throw "argument 'id' must be defined" unless id = opts["id"]
      @user = Smoothie::User.new(id)
    end

    # Does the syncing need to be done
    def ready?
      @user.synced?
    end

    # Sync the user
    def perform
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

  end
end