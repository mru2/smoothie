require 'user'
require 'soundcloud_client'
require 'chainable_job/base_job'

module Smoothie
  class UserSyncer < Smoothie::ChainableJob::BaseJob

    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']

      @user = Smoothie::User.new(@arguments['id'])
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
      @user.set_synced!
    end

  end
end