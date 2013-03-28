require 'spec_helper'

require 'track_syncer'

describe Smoothie::TrackSyncer do

  let(:track_id){293}
  let(:syncer){Smoothie::TrackSyncer.new(track_id)}

  describe "#run" do

    it "should work" do
      track = Smoothie::Track.new(track_id)

      track.synced?.should          be_false

      res = syncer.run

      track.synced?.should          be_true

      track.title.value.should==          "Flickermood"
      track.artwork.value.should ==       "http://i1.sndcdn.com/artworks-000000001720-91c40a-large.jpg?ca77017"
      track.url.value.should ==           "http://soundcloud.com/forss/flickermood"
      track.uploader_name.value.should==  "Forss"
      track.uploader_url.value.should==   "http://soundcloud.com/forss"

    end

  end
 
end