# Responsible for computing track recommendations for users
module Smoothie
	module RecommenderEngine

    User = Struct.new(:tracks_count, :track_ids, :score)
    Track = Struct.new(:users_count,  :score)

    class Engine
      attr_reader :users, :tracks

      def initialize(user, opts={})
        @user      = user
        @track_ids = SortedSet.new @user.track_ids.members

        @users = {}
        @tracks = {}

        initialize_graph!
      end


      def initialize_graph!

        @track_ids.each do |track_id|
          track = Smoothie::Track.new(track_id)

          next unless track.synced? && track.favoriters_synced?

          sync_users!(track)
        end


        @users.each do |user_id, user_details|
          user_details.track_ids.each do |track_id|
            next if @track_ids.include? track_id

            track = Smoothie::Track.new(track_id)

            next unless track.synced?

            add_track!(track, user_details.score)
          end
        end

      end


      # Find the users with the most common tracks
      def sync_users!(track)
        track_score = 1.to_f / track.users_count.value.to_i

        user_ids = track.user_ids.members

        user_ids.each do |user_id|
          next if user_id == @user.id

          user = Smoothie::User.new(user_id)

          next unless user.synced? && user.favorites_synced?

          add_user!(user, track_score)
        end
      end


      def add_user!(user, track_score)
        user_tracks_count = user.tracks_count.value.to_i

        @users[user.id]        ||=  Smoothie::RecommenderEngine::User.new(user_tracks_count, user.track_ids.members, 0)
        @users[user.id].score  +=   track_score / user_tracks_count
      end


      def add_track!(track, user_score)
        track_users_count = track.users_count.value.to_i

        @tracks[track.id]       ||= Smoothie::RecommenderEngine::Track.new(track_users_count, 0)
        @tracks[track.id].score += user_score / track_users_count
      end


      def recommended_tracks
        return @tracks.map{|t|[t.first, t.last.score]}
      end

    end
  end
end