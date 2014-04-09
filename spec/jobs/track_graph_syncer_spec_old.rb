require 'spec_helper'
require 'track_graph_syncer'

describe Smoothie::TrackGraphSyncer do

  let(:user_id){3207}
  let(:syncer){Smoothie::TrackGraphSyncer.new('id' => user_id)}

	it "should work" do

		VCR.use_cassette('track_graph_syncer') do
			syncer.run
		end

	end

end
