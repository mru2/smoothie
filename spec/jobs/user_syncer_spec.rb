require 'spec_helper'

require 'user_syncer'

describe Smoothie::UserSyncer do

  let(:user_id){3207}
  let(:syncer){Smoothie::UserSyncer.new('id' => user_id)}

  describe "#run" do

    it "should work" do
      user = Smoothie::User.new(user_id)

      user.synced?.should be_false

      syncer.run

      user.synced?.should be_true

      user.username.value.should  == "Johannes Wagener"
      user.url.value.should       == "http://soundcloud.com/jwagener"
    end

  end
 
end