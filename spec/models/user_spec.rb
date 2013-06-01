require 'spec_helper'
require 'user'

describe Smoothie::User do

  let(:user_id){1}
  let(:user){Smoothie::User.new(user_id)}

  describe "#favorites_up_to_date?" do

    it "should be true for favorites synced up to the day before" do
      user.favorites_up_to_date?.should be_false

      user.favorites_synced_at = Time.now - Smoothie::User::FAVORITES_EXPIRATION - 60
      user.favorites_up_to_date?.should be_false

      user.favorites_synced_at = Time.now - Smoothie::User::FAVORITES_EXPIRATION + 60
      user.favorites_up_to_date?.should be_true
    end

  end

end