require 'spec_helper'

require 'api_fetch/track_syncer'

describe Smoothie::ApiFetch::TrackSyncer do

  let(:track_id){293}
  let(:syncer){Smoothie::ApiFetch::TrackSyncer.new('id' => track_id)}

  describe "#run" do

    it "should work" do
      track = Smoothie::Track.new(track_id)

      track.synced?.should be_false

      syncer.run

      track.synced?.should be_true

      track.users_count.value.should== "985"
    end

  end
 
end