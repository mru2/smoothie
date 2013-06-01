require 'spec_helper'
require 'shuffler'

describe Smoothie::Shuffler do

  let(:values){(1..100).to_a}
  let(:seed){47654062875820368259408902495896546132}
  let(:shuffler){Smoothie::Shuffler.new(values, seed)}

  describe "#shuffle" do

    it "should shuffle the array" do

      shuffler.get.should_not == values

    end

    it "should keep the same results" do

      get = shuffler.get
      get.should == shuffler.get

    end

    it "should handle empty arrays" do
      Smoothie::Shuffler.new([], seed).get.should == []
    end

    it "should be consistent" do

      Smoothie::Shuffler.new(values, seed).get.should == Smoothie::Shuffler.new(values, seed).get

    end

    it "should not change the original array" do

      other_values = (1..10).to_a
      Smoothie::Shuffler.new(other_values, seed).get
      other_values.should == (1..10).to_a

    end

    it "should allow offset and limit" do
      shuffler.get(:offset => 5, :limit => 15).last(5).should == shuffler.get(:offset => 15, :limit => 20).first(5)
    end

    it "should cycle through results" do
      shuffler.get(:offset => 105).length.should == 10
      shuffler.get(:offset => 99).length.should == 10
    end

  end

end