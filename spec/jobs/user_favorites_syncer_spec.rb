require 'spec_helper'
require 'api_fetch/user_favorites_syncer'

describe Smoothie::ApiFetch::UserFavoritesSyncer do

  let(:user_id){2339203}
  let(:user){Smoothie::User.new(user_id)}
  let(:syncer){Smoothie::ApiFetch::UserFavoritesSyncer.new('id' => user_id)}

  describe "#run" do

    it "should fetch the user before" do
      syncer.should_receive(:wait_for).with(Smoothie::ApiFetch::UserSyncer.new({'id' => user_id}))

      VCR.use_cassette("user_favorites_syncer_#{user_id}") do
        syncer.run
      end
    end

    it "should fetch all the favorites and clear the old ones" do
      user.track_ids << (1..1000).to_a
      user.track_ids.count.should == 1000

      VCR.use_cassette("user_favorites_syncer_#{user_id}") do
        syncer.run
      end

      user.track_ids.count.should == user.tracks_count.value.to_i
    end

    it "should set the favorites synced at timestamp after finishing" do
      user.favorites_synced_at = Time.now - 10*(24*3600)
      syncer = Smoothie::ApiFetch::UserFavoritesSyncer.new('id' => user_id)

      VCR.use_cassette("user_favorites_syncer_#{user_id}") do
        syncer.run
      end

      user.favorites_synced_at.value.should == Time.now.to_s
    end

  end

end