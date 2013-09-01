# Responsible for computing track recommendations for users
module Smoothie
	class Recommender

    def initialize(user, opts={})
      @user           = user
      @my_track_ids   = @user.track_ids.members
      @my_tracks      = @my_track_ids.map{|track_id|Smoothie::Track.new(track_id)}
      @my_friends     = @my_tracks.map{|track|track.user_ids.members}
                        .flatten.uniq.reject{|user_id|user_id == @user.id}
                        .map{|user_id|Smoothie::User.new(user_id)}
                        .select{|user|(user.track_ids.members & @my_track_ids).count > 1}
      @track_graph    = @my_friends.map{|user|user.track_ids.members}
                        .flatten.uniq.reject{|track_id|@my_track_ids.include? track_id}
                        .map{|track_id|Smoothie::Track.new(track_id)}

      @users_scores   = {}
    end

    def recommended_tracks

      # Get all the related tracks
      track_scores = Hash[@track_graph.map{|track|[track, get_track_score(track)]}]

      sorted_track_scores = track_scores.sort_by{|k,v|-v}

      return sorted_track_scores.first(50).map{|t|[t.first.id, t.last]}

    end


    private

    def get_track_score(track)

      # Get the number of users who have the track
      track_users = @my_friends.select{|u|u.track_ids.include? track.id}

      track_users.map{|user|get_user_score(user)}.reduce(&:+)

    end

    def get_user_score(user)
      # Returns the number of tracks in common divided by the track count
      return @users_scores[user.id] if @users_scores[user.id]

      score = (user.track_ids.members & @my_track_ids).count * 1.0 / (user.tracks_count.value.to_i)
      @users_scores[user.id] = score
      return score
    end

  end
end