require 'spec_helper'

require 'user_favorites_syncer'

describe Smoothie::UserFavoritesSyncer do

  let(:user_id){3207}
  let(:user){Smoothie::UserFavoritesSyncer.new(user_id)}
  let(:syncer){Smoothie::UserFavoritesSyncer.new(user_id)}

  describe "#run" do

    it "should work" do
      user = Smoothie::User.new(user_id)

      user.tracks.should be_empty

      res = syncer.run

      user.tracks.should_not be_nil
    end

  end
 
end