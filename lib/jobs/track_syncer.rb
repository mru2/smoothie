require 'worker'
require 'track'
require 'user'

module Smoothie::Jobs

  class TrackSyncer

    DEFAULT_DELAY = 3600 # 1 hour
    MAX_DELAY = 86400 # 1 day
    LIKE_THRESHOLD = 200

    class << self

      # Only static methods
      def run(track_id)

        base_key = "smoothie:jobs:track_syncer:#{track_id}:"
        sync_key = base_key + "sync"
        likers_key = base_key + "likers"
        delay_key = base_key + "delay"

        # Get the track
        track = Smoothie::Track.find(track_id)
        raise "No track found for #{track_id}" unless track


        # Check if already synced
        return if $redis.exists sync_key


        # Get the likers on soundcloud
        likers = $soundcloud.get_track_likers(track_id)
        users = likers.map{|soundcloud| Smoothie::User.from_soundcloud(soundcloud)}
        track.add_users(users)


        # Check the likers delta for the next sync
        former_likers = $redis.get(likers_key).to_i
        former_delay = $redis.get(delay_key).to_i
        next_delay = get_next_delay(former_delay, former_likers, track.attributes[:likers])
        $redis.set likers_key, track.attributes[:likers]
        $redis.set delay_key, next_delay


        # Set the synced flag
        $redis.set sync_key, Time.new.to_i
        $redis.expire sync_key, next_delay


        # Enqueue the likers
        likers.each do |user|
          Smoothie::Jobs::Worker.enqueue :user, user.id
        end

      end


      def get_next_delay(former_delay, former_likers, new_likers)

        return DEFAULT_DELAY unless former_likers && former_delay

        likers_delta = new_likers - former_likers

        # Losing likers?! => let him sleep longer
        if (likers_delta <= 0)
          next_delay = (former_delay * 1.5).round
        else
          # Calculate the optimal delay (assume constant growth)
          next_delay = ( former_delay * LIKE_THRESHOLD / likers_delta ).to_i
        end

        next_delay = MAX_DELAY if next_delay > MAX_DELAY
        return next_delay

      end

    end

  end

end