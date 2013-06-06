require 'spec_helper'
require 'api_fetch/user_favorites_syncer'

describe Smoothie::ApiFetch::UserFavoritesSyncer do

  let(:user_id){2339203}
  let(:user){Smoothie::User.new(user_id)}
  let(:limit){15}
  let(:syncer){Smoothie::ApiFetch::UserFavoritesSyncer.new('id' => user_id, 'limit' => limit)}

  describe "#run" do

    it "should fetch the user before" do
      syncer.should_receive(:wait_for).with(Smoothie::ApiFetch::UserSyncer.new({'id' => user_id}))

      VCR.use_cassette("user_favorites_syncer_#{user_id}") do
        syncer.run
      end
    end

    it "should fetch the favorites" do
      user.track_ids.count.should == 0

      VCR.use_cassette("user_favorites_syncer_#{user_id}") do
        syncer.run
      end

      user.track_ids.count.should == limit
    end

    it "should be able to fetch all" do
      syncer = Smoothie::ApiFetch::UserFavoritesSyncer.new('id' => user_id, 'limit' => 'all')

      VCR.use_cassette("user_favorites_syncer_#{user_id}") do
        syncer.run
      end

      user.track_ids.count.should_not == 0
      user.track_ids.count.should == user.tracks_count.value.to_i
    end

    it "should clear the existing favorites when fetching all" do

    end

    it "should set the favorites synced at timestamp after finishing" do

    end

  end

end