require 'spec_helper'

require 'track_syncer'

describe Smoothie::TrackSyncer do

  let(:track_id){293}
  let(:syncer){Smoothie::TrackSyncer.new(track_id)}

  describe "#run" do

    it "should work" do
      track = Smoothie::Track.new(track_id)

      track.synced_at.should be_nil

      res = syncer.run

      track.synced_at.should_not be_nil
      track.uploader_id.should_not be_nil
    end

  end
 
end