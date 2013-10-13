# Responsible for computing track recommendations for users
module Smoothie
	module RecommenderEngine

    User = Struct.new( :total_tracks_count, :common_track_ids, :score) do
      def common_tracks_count
        common_track_ids.count
      end 
    end

    Track = Struct.new(:total_users_count,  :common_user_ids,  :score) do
      def common_users_count
        common_user_ids.count
      end
    end


    class Strategy

      def select_my_track(track)
        true
      end

      def score_my_track(track)
        1
      end

      def select_user(user)
        user.common_tracks_count > 10 && user.total_tracks_count > 100
      end

      def score_user(user)
        return 0 if user.total_tracks_count == 0
        user.common_tracks_count.to_f # / Math.sqrt(user.total_tracks_count)
      end

      def select_track(track)
        track.common_users_count > 10
      end

      def score_track(track)
        return 0 if track.total_users_count == 0
        track.common_users_count.to_f # / Math.sqrt(track.total_users_count)
      end

    end


    class Engine
      attr_reader :users, :tracks

      def initialize(user, opts={})
        @user      = user
        @strategy  = opts['strategy'] || Strategy.new

        @my_tracks = {}
        @users     = {}
        @tracks    = {}
        @debug     = !!opts['debug']

        if opts['dump']
          load_dump!(opts['dump'])
        else
          fetch!
        end

        log "Got #{@my_tracks.count} tracks #{@users.count} users and #{@tracks.count} potential tracks"
      end


      # Fetch the graph
      def fetch!

        log("Fetching my tracks")

        fetch_my_tracks!

        log("Fetching tracks")

        @my_tracks.each do |track_id, track_details|
          track = Smoothie::Track.new(track_id)

          next unless track.synced? && track.favoriters_synced?

          fetch_users!(track)
        end

        log("Fetching users")

        @users.each do |user_id, user_details|
          user = Smoothie::User.new(user_id)

          next unless user.synced? && user.favorites_synced? && user.id != @user.id.to_s

          fetch_tracks!(user)
        end

      end


      # Score the tracks
      def score!

        log("Scoring my tracks")
        @my_tracks = @my_tracks.select{|track_id, track| @strategy.select_my_track(track)}
        @my_tracks.each{|track_id, track| track.score = @strategy.score_my_track(track)}

        log("Scoring users")
        @users = @users.select{|user_id, user| @strategy.select_user(user)}
        @users.each do |user_id, user|
          user_score = @strategy.score_user(user)
          user.score = user_score * ( (user.common_track_ids.map{|track_id|@my_tracks[track_id]}.compact.map(&:score).reduce(&:+)) || 0 )
        end

        log("Scoring tracks")
        @tracks = @tracks.select{|track_id, track| @strategy.select_track(track)}
        @tracks.each do |track_id, track|
          track_score = @strategy.score_track(track)
          track.score = track_score * ( (track.common_user_ids.map{|user_id|@users[user_id]}.compact.map(&:score).reduce(&:+)) || 0 )
        end

      end

      # Get the top users
      def top_users(limit = 10)
        @users.sort_by{|user_id,user| -user.score}.first(limit).map do |t|
          {
            :id => t.first,
            :score => t.last.score,
            :common_tracks_count => t.last.common_tracks_count,
            :total_tracks_count => t.last.total_tracks_count
          }
        end
      end

      def top_tracks(limit = 10)
        @tracks.sort_by{|track_id,track| -track.score}.first(limit).map do |t|
          {
            :id => t.first,
            :score => t.last.score,
            :common_users_count => t.last.common_users_count,
            :total_users_count => t.last.total_users_count
          }
        end
      end


      # Fetching my tracks
      def fetch_my_tracks!
        @user.track_ids.members.each do |track_id|
          track = Smoothie::Track.new(track_id)
          next unless track.synced? && track.favoriters_synced?

          @my_tracks[track_id] = Smoothie::RecommenderEngine::Track.new.tap{|t|
            t.total_users_count = track.users_count.value.to_i
            t.common_user_ids = []
            t.score = 0
          }

        end
      end


      # Fetch the users who liked my favorites
      def fetch_users!(track)
        log("Fetching users for track #{track.id}")

        user_ids = track.user_ids.members

        user_ids.each do |user_id|
          next if user_id == @user.id.to_s

          user = Smoothie::User.new(user_id)

          next unless user.synced? && user.favorites_synced?

          add_user!(user, track)
        end
      end


      # Fetch the tracks liked by my network
      def fetch_tracks!(user)
        log("Fetching tracks for user #{user.id}")

        track_ids = user.track_ids.members

        track_ids.each do |track_id|
          next if @my_tracks.keys.include? track_id

          track = Smoothie::Track.new(track_id)

          next unless track.synced?

          add_track!(track, user)
        end
      end


      def add_user!(smoothie_user, favorite)
        @users[smoothie_user.id] ||= Smoothie::RecommenderEngine::User.new.tap{|u|
          u.total_tracks_count = smoothie_user.tracks_count.value.to_i
          u.common_track_ids = []
          u.score = 0
        }

        @users[smoothie_user.id].common_track_ids << favorite.id
      end


      def add_track!(smoothie_track, user)
        @tracks[smoothie_track.id] ||= Smoothie::RecommenderEngine::Track.new.tap{|t|
          t.total_users_count = smoothie_track.users_count.value.to_i
          t.common_user_ids = []
          t.score = 0
        }

        @tracks[smoothie_track.id].common_user_ids << user.id
      end


      def log(str)
        puts str if @debug
      end


      def load_dump!(dump)
        (@my_tracks, @users, @tracks) = Marshal.load(dump)
      end

      def dump
        Marshal.dump [@my_tracks, @users, @tracks]
      end

    end
  end
end