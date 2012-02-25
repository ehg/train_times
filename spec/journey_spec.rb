require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../journey.rb'

WebMock.allow_net_connect!

describe Journey do
  context "When home is nearer to my location than the office" do
    before do
      current_location = [53.492362, -3.030396]
      @journey = Journey.new current_location 
    end

    it "should set the train origin to Southport" do
      @journey.train_origin.should == "Southport"
    end
  end

  context "When the office is nearer to my location than home" do
    before do
      current_location = [53.402963, -2.984758]
      @journey = Journey.new current_location 
    end

    it "should set the train origin to Hunts Cross" do
      @journey.train_origin.should == "Hunts Cross"
    end
  end
end
