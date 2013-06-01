# encoding: utf-8
require 'shuffler'
require 'playlist_syncer'


# Class responsible for building a user's playlist from various criteria

module Smoothie
  class PlaylistBuilder

    attr_reader :seed

    def initialize(user, seed)
      @user = user
      @seed = (seed && seed.to_i) || Random.new_seed

      raise(ArgumentError, "user must be defined") unless @user
    end

    # Returns the playlist's track ids.
    # Options : limit (default 10) and offset (default 0)
    def track_ids(opts = {})
      limit  = opts[:limit] ? opts[:limit].to_i : 10
      offset = opts[:offset].to_i # Defaulting to 0

      shuffler = Smoothie::Shuffler.new(favorite_track_ids, @seed)
      return shuffler.get(:offset => offset, :limit => limit)
    end


    private

    # The pool of favorite tracks on which the shuffle is made
    def favorite_track_ids

      # Compute them if not present or out of date
      unless @user.favorites_up_to_date?
        Smoothie::PlaylistSyncer.new('id' => @user.id, 'limit' => 'all').run
      end

      # Cache and return them
      @favorite_track_ids ||= @user.track_ids.members 
    end

  end
end