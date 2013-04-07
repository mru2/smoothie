require 'spec_helper'

require 'user_favorites_syncer'

describe Smoothie::UserFavoritesSyncer do

  let(:user_id){3207}
  let(:syncer){Smoothie::UserFavoritesSyncer.new('id' => user_id, 'limit' => 2)}

  describe "#run" do

    it "should work" do
      user = Smoothie::User.new(user_id)

      user.favorites_synced?.should be_false

      syncer.run

      user.favorites_synced?.should be_true

      user.tracks.count.should                == 2
      user.tracks.map(&:synced?).should       == [true, true]
    end

  end
 
end