require 'spec_helper'
require 'user'

describe Smoothie::User do

  let(:user_id){1}
  let(:user){Smoothie::User.new(user_id)}

  describe "#synced?" do

    describe "without arguments" do

      it "should be false for unsynced users" do
        user.synced?.should be_false
      end

      it "should be true for synced users, whatever their value" do
        user.synced_at = Time.new(0)
        user.synced?.should be_true        
      end

    end


    describe "with arguments" do

      let(:delay){Smoothie::User::EXPIRATION}

      it "should be false for unsynced users" do
        user.synced?(delay).should be_false
      end

      it "should be true for users synced after the given delay" do
        user.synced_at = Time.now - delay

        user.synced?(delay-1).should be_false
        user.synced?(delay+1).should be_true
      end

    end

  end

end