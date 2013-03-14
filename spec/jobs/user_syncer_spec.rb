require 'spec_helper'

require 'user_syncer'

describe Smoothie::UserSyncer do

  let(:user_id){3207}
  let(:syncer){Smoothie::UserSyncer.new(user_id)}

  describe "#run" do

    it "should work" do
      user = Smoothie::User.new(user_id)

      user.synced_at.should be_nil

      res = syncer.run

      user.synced_at.should_not be_nil
    end

  end
 
end