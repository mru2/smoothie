require 'spec_helper'

require 'api_fetch/user_syncer'

describe Smoothie::ApiFetch::UserSyncer do

  let(:user_id){2339203}
  let(:syncer){Smoothie::ApiFetch::UserSyncer.new('id' => user_id)}

  describe "#run" do

    it "should work" do
      user = Smoothie::User.new(user_id)

      user.synced?.should be_false

      VCR.use_cassette("user_syncer_#{user_id}") do
        syncer.run
      end

      user.synced?.should be_true

      user.tracks_count.value.should  == "468"
    end

  end
 
end