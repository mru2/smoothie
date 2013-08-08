require 'spec_helper'
require 'playlist_syncer'

describe Smoothie::PlaylistSyncer do

  let(:user_id){3207}
  let(:syncer){Smoothie::PlaylistSyncer.new('id' => user_id)}

  describe "#run" do

    it "should call the user favorites syncer" do

      user = Smoothie::User.new(user_id)
      user.favorites_synced?.should be_false

      syncer.should_receive(:wait_for).with(Smoothie::ApiFetch::UserFavoritesSyncer.new('id' => user_id))

      syncer.run

    end

  end
 
end