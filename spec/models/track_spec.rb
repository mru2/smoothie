require 'spec_helper'
require 'track'

describe Smoothie::Track do

  let(:id){123456}
  let(:title){"A title"}
  let(:uploader_name){"A uploader name"}
  let(:uploader_url){"uploader.url"}
  let(:artwork){"artwork.url"}
  let(:url){"track.url"}

  let(:track){
    t = Smoothie::Track.new(id)
    t.title   = title
    t.artwork = artwork
    t.url     = url
    t.stub!(:uploader_name).and_return(uploader_name)
    t.stub!(:uploader_url).and_return(uploader_url)
    return t
  }

  describe "#serialize" do

    it "should work" do

      track.serialize.should == {
        :id => id, 
        :title => title, 
        :url => url, 
        :artwork => artwork, 
        :uploader_name => uploader_name, 
        :uploader_url => uploader_url
      }

    end

  end

end