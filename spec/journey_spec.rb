require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../journey.rb'


describe Journey do
  use_vcr_cassette 'requests'

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

  context "When my location is real (crosby)" do
    
    before do
      @journey = Journey.new MyLocation.get
      @journey.current_date = DateTime.new(2012, 02, 20, 8, 10)
    end

    it "should set the train origin to Southport" do
      @journey.train_origin.should == "Southport"
    end

    it "should return the next two trains" do
      @journey.next_trains.length.should == 2
    end
  end
end
