module Smoothie
  class UserFavoritesSyncer

    include Celluloid

    def initialize(user_id)
      @user = User.new(user_id)
    end


    def run
      perform! unless syncing_done?
      return @user.tracks
    end

    private

    def perform!
      
    end

  end
end