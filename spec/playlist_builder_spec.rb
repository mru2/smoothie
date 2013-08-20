require 'spec_helper'
require 'playlist_builder'

describe Smoothie::PlaylistBuilder do

  let(:user_id){1234}
  let(:user){Smoothie::User.new(user_id)}
  let(:seed){123456}
  let(:playlist_builder){Smoothie::PlaylistBuilder.new(user, seed)}

  describe "#track_ids" do

    it "should return a shuffle of the users favorites" do

      user.stub_chain(:track_ids, :members).and_return((1..100).to_a)

      res = playlist_builder.track_ids

      res.should == [23, 12, 60, 63, 34, 42, 98, 91, 78, 28]

    end
     
    it "should try to run the syncing" do

      playlist_syncer = mock('a playlist syncer')
      Smoothie::PlaylistSyncer.stub(:new).and_return(playlist_syncer)

      Smoothie::PlaylistSyncer.should_receive(:new).with({'id' => user_id})
      playlist_syncer.should_receive(:async_run)

      # Hack for rest of execution, find a way to remove it
      user.stub_chain(:track_ids, :members).and_return([])

      playlist_builder.track_ids

    end

  end

end