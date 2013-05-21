require 'spec_helper'
require 'playlist_syncer'

describe Smoothie::PlaylistSyncer do

  let(:user_id){3207}
  let(:syncer){Smoothie::PlaylistSyncer.new('id' => user_id, 'limit' => 2)}

  describe "#run" do

    it "should work" do

      user = Smoothie::User.new(user_id)

      user.favorites_synced?.should be_false

      syncer.run

      user.favorites_synced?.should be_true

      user.track_ids.count.should == 2
    end

  end
 
end