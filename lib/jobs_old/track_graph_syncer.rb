# Fetches a users's track graph (favorite tracks of users who favorited the same tracks as the first one)
# Need to sync the tracks / users until the last level, to get their favorites / favoriters count

require 'base_job'
require 'user'
require 'track'
require 'set'
  
module Smoothie
  class TrackGraphSyncer < Smoothie::BaseJob

    include Resque::Plugins::UniqueJob

    @queue = :api

    DEFAULT_LIMIT = 200
    EXPIRATION = 86400 # 1 day


    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      
      @user = Smoothie::User.new(@arguments['id'])

      @user_graph = {}  # Key : user_id ; value : common tracks count
      @track_graph = {} # Key : track_id ; value : common users count
    end


    def ready?
      @user.track_graph_synced?(EXPIRATION)
    end


    # Naive implementation, to make recursive when a little more mature
    # Complexity : NxLxL -- N : size of user playlist -- L : limit size
    def perform

      # 1. Resync the user and get its last favorites
      @user.sync!
      last_favorites = @user.sync_favorites!(:limit => DEFAULT_LIMIT)


      # 2. Sync its last favorites (filling the @users graph)
      last_favorites.each do |track_id|
        sync_track!(track_id)
      end


      # 3. Select the top users (the ones with most tracks in common)
      top_users = @user_graph.sort_by{|k,v| -v}.first(DEFAULT_LIMIT).map(&:first)


      # 4. Sync them (filling the @tracks graph)
      top_users.each do |user_id|
        sync_user!(user_id)
      end


      # 5. Select the top tracks (most liked by the top users)
      top_tracks = @track_graph.sort_by{|k,v| -v}.first(DEFAULT_LIMIT).map(&:first)


      # 6. Sync them (for their user count)
      top_tracks.each do |track_id|
        track = Smoothie::Track.new(track_id)
        track.sync!
      end

    end


    private

    # Sync a user's favorite, and store its details
    def sync_track!(track_id)

      track = Smoothie::Track.new(track_id)

      # Sync the track and its favoriters
      track.sync!
      favoriters_ids = track.sync_favoriters!(:limit => DEFAULT_LIMIT)

      # Store the favoriters in the graph
      favoriters_ids.each do |user_id|
        next if user_id == @user.id

        @user_graph[user_id] ||= 0
        @user_graph[user_id] += 1

      end
    end


    # Sync an interesting user and its favorites
    def sync_user!(user_id)

      user = Smoothie::User.new(user_id)

      # Sync the user and its favorites
      user.sync!
      favorites_ids = user.sync_favorites!(:limit => DEFAULT_LIMIT)

      # Store the track in the graph
      favorites_ids.each do |track_id|
        next if @user.track_ids.include? track_id

        @track_graph[track_id] ||= 0
        @track_graph[track_id] += 1

      end
    end

  end
end
