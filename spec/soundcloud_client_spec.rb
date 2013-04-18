require 'spec_helper'
require 'soundcloud_client'

describe Smoothie::SoundcloudClient do

  let(:client){ Smoothie::SoundcloudClient.new }
 
  before(:each) do
    # A mock for the actual souncloud api client
    @api = mock(Soundcloud).as_null_object
    Soundcloud.stub(:new).and_return(@api)
  end

  describe "#api" do

    it "should create an api wrapper if not existing" do
      Soundcloud.should_receive(:new)
      api = client.client
      api.should == @api
    end

    # it "should check the expiration date if existing for each access" do
    #   client.api
    #   @api.should_receive(:expired?)
    #   client.api
    # end

    # it "should refresh itself if expired" do
    #   client.api
    #   @api.stub(:expired?).and_return(true)
    #   Soundcloud.should_receive(:new)
    #   client.api        
    # end

  end


  let(:user_id){123456}

  describe "#get_user" do
    let(:user_id){123456}

    it "should fetch the user" do
      @api.should_receive("get").with("/users/#{user_id}")

      client.get_user(user_id)
    end
  end

  describe "#get_user_favorites" do
    it "should fetch the user favorites" do
      @api.should_receive("get").with("/users/#{user_id}/favorites", {:limit => 52, :offset => 0})

      client.get_user_favorites(user_id, 52)
    end


    it "should handle pages properly" do
      @api.should_receive("get").with("/users/#{user_id}/favorites", {:limit => 200, :offset => 0})
      @api.should_receive("get").with("/users/#{user_id}/favorites", {:limit => 200, :offset => 200})
      @api.should_receive("get").with("/users/#{user_id}/favorites", {:limit => 100, :offset => 400})

      client.get_user_favorites(user_id, 500)
    end
  end


  let(:track_id){123456}

  describe "#get_track" do

    it "should fetch the track" do
      @api.should_receive("get").with("/tracks/#{track_id}")

      client.get_track(track_id)
    end
  
  end

end
