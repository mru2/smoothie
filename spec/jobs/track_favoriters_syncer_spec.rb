require 'spec_helper'
require 'api_fetch/track_favoriters_syncer'

describe Smoothie::ApiFetch::TrackFavoritersSyncer do

  let(:track_id){87037634}
  let(:track){Smoothie::Track.new(track_id)}
  let(:syncer){Smoothie::ApiFetch::TrackFavoritersSyncer.new('id' => track_id)}


  describe "#run" do

  end

end