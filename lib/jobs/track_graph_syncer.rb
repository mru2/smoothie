# Fetches a users's track graph (favorite tracks of users who favorited the same tracks as the first one)
# Need to sync the tracks / users until the last level, to get their favorites / favoriters count


# Track favoriters:
# min: 1
# max: 79054

# mean : 2709
# median : 551
# deviation : 7138

# User occurences:
# min : 1
# max : 139

# mean : 1.6
# median : 1

# 27% > 1
# 2% > 5
# 0.4% > 10
# 0.04% > 20


# User tracks ratio
# *only > 20 common (178)*
# mean : 1.78%
# median : 1.28%
# deviation: 1.44%



require 'base_job'
require 'user'
require 'track'
  
module Smoothie
  class TrackGraphSyncer < Smoothie::BaseJob

    @queue = :default

    DEFAULT_LIMIT = 200
    EXPIRATION = 86400 # 1 day

    def initialize(opts = {})
      super

      throw "id must be defined" unless @arguments['id']
      
      @user = Smoothie::User.new(@arguments['id'])
    end

    def ready?
      @user.track_graph_synced?(EXPIRATION)
    end


    # Naive implementation, to make recursive when a little more mature
    # Complexity : NxLxL -- N : size of user playlist -- L : limit size
    def perform

      # First resync the user
      @user.sync!


      # Then sync its last favorites
      new_favorites = @user.sync_favorites!(:limit => DEFAULT_LIMIT)

      new_favorites.each do |track_id|
        track = Smoothie::Track.new(track_id)

        # Sync its favorites details
        track.sync!

        # Sync its favoriters
        track.sync_favoriters!(:limit => DEFAULT_LIMIT)
      end


      # Select the top users
      top_favoriters = select_top_users(DEFAULT_LIMIT)

      top_favoriters.each do |user|
        # Sync the user details
        user.sync!

        # Sync their favorites
        user.sync_favorites!(:limit => DEFAULT_LIMIT)
      end


      # Set the track graph synced
      @user.track_graph_synced_at = Time.now

    end


    private

    # Select the users most likely to have interesting tracks
    # Since they are not synced, we just have to select the ones with the
    # most tracks in common with the current user
    def select_top_users(limit)

      # Count the tracks in common
      # Hash {user_id => common tracks count}
      common_tracks_count = Hash[all_users.map{|user|[user.id, 0]}]

      all_users.each do |user|
        common_tracks_count[user.id] = count_common_tracks(user)
      end

      # Return the top users
      common_tracks_count.sort_by{|k,v|v}.last(limit).map(&:first).map{|user_id|Smoothie::User.new(user_id)}

    end


    # All the other users in the graph
    def all_users
      @all_users ||=  @user
                      .track_ids.members.map{|track_id| Smoothie::Track.new(track_id)}
                      .map{|track|track.user_ids.members}
                      .flatten.uniq.reject{|user_id| user_id == @user.id}
                      .map{|user_id|Smoothie::User.new(user_id)}
    end


    def count_common_tracks(user)
      (user.track_ids.members & @user.track_ids.members).count
    end

  end
end
