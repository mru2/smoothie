require 'spec_helper'
require 'user_syncer'

describe Smoothie::Jobs::UserSyncer do

  let(:user_id){'userid'}

  describe "#run" do

    it "should ignore synced track" do
      $redis.stub(:exists).with("smoothie:jobs:user_syncer:#{user_id}:sync").and_return('foobar')
      Smoothie::Jobs::UserSyncer.run user_id
    end

    it "should handle first sync" do
      $soundcloud.stub(:foo)

      # Stub likes and attrs
      $soundcloud.stub(:get_user).with(user_id).and_return([
        OpenStruct.new(:public_favorites_count => 12),
        (1..12).to_a
      ])

      # Sync date should be set
      $redis.should_receive(:expire).with("smoothie:jobs:user_syncer:#{user_id}:sync", 86400)

      # Tracks should be enqueued
      (1..12).each do |i|
        Smoothie::Jobs::Worker.should_receive(:enqueue).with(:track, i)
      end

      Smoothie::Jobs::UserSyncer.run user_id

      $redis.get("smoothie:jobs:user_syncer:#{user_id}:sync").should == Time.now.to_i.to_s
      $redis.get("smoothie:jobs:user_syncer:#{user_id}:likes").should == 12.to_s
      $redis.get("smoothie:jobs:user_syncer:#{user_id}:delay").should == 86400.to_s

    end



  end

end
