# Responsible for computing track recommendations for users
module Smoothie
	module Recommender

    User = Struct.new(:score, :common_tracks_count, :track_ids)
    Track = Struct.new(:score, :user_ids)

    class Engine
      attr_reader :users, :tracks

      def initialize(user, opts={})
        @user      = user
        @track_ids = SortedSet.new @user.track_ids.members

        @users = {}
        @tracks = {}

        initialize_graph!
        score_users!
        score_tracks!
      end


      def initialize_graph!
        all_user_ids = SortedSet.new

        @track_ids.each do |track_id|
          all_user_ids.merge Smoothie::Track.new(track_id).user_ids.members
        end

        all_user_ids.each do |user_id|

          next if user_id == @user.id

          common_tracks_count = 0
          track_ids = Smoothie::User.new(user_id).track_ids.members.reject{|track_id|@track_ids.include?(track_id) && true.tap{common_tracks_count += 1}}

          @users[user_id] = Smoothie::Recommender::User.new(0, common_tracks_count, SortedSet.new(track_ids))

          track_ids.each do |track_id|
            @tracks[track_id] ||= Smoothie::Recommender::Track.new(0, SortedSet.new())
            @tracks[track_id].user_ids << user_id
          end
        end
      end


      def score_users!
        @users.each do |user_id, user|
          total_tracks_count = Smoothie::User.new(user_id).tracks_count.value.to_i
          if total_tracks_count
            user.score = user.common_tracks_count * 1.0 / total_tracks_count
          else
            user.score = 0
          end
        end
      end


      def score_tracks!
        @tracks.each do |track_id, track|
          track.score = track.user_ids.map{|user_id|@users[user_id].score}.inject(:+)
        end
      end


      def recommended_tracks
        sorted_tracks = @tracks.sort_by{|k,v|-v.score}
        return sorted_tracks.first(50).map{|t|[t.first, t.last.score]}
      end

    end
  end
end