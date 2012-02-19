require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../nearest_nl_station.rb'

WebMock.allow_net_connect!

describe NearestNorthernLineStation do
  it "should fetch a list of Northern Rail stations from the ScraperWiki API" do
    a_request(:get, 
              "https://api.scraperwiki.com/api/1.0/datastore/sqlite?format=jsondict&name=stationsmerseyrail&query=SELECT%20Code%2C%20%5Bstation%20name%5D%2C%20latlng%20from%20%60swdata%60%20WHERE%20Lines%20LIKE%20'%25Northern%20Line%25'"
             ).should have_been_made 
  end

  it "should have a list of Merseyrail stations" do
    stations = NearestNorthernLineStation.stations
    stations.should_not be_nil
    stations.should be_a_kind_of Hash
    stations.count.should > 1
  end
  
  it "should have Liverpool Central in its list inc. its code, name, lat, long & lines" do
    station = NearestNorthernLineStation.stations['LVC']
    station.should_not be_nil
    station[:name].should_not be_nil
    station[:latitude].should_not be_nil
    station[:longitude].should_not be_nil
  end
  
  it "should have Liverpool Moorfields in its list inc. its code, name, lat, long & lines" do
    station = NearestNorthernLineStation.stations['MRF']
    station.should_not be_nil
    station[:name].should_not be_nil
    station[:latitude].should_not be_nil
    station[:longitude].should_not be_nil
  end


  context "When I am at work in ScraperWiki" do
    before do
      @location = [53.405696, -2.970465]
    end

    it "should detect my nearest railway station is Liverpool Central" do
      NearestNorthernLineStation.get(@location).should == "LVC"
    end
  end
  
  context "When I am having a drink at the Railway" do
    before do
      @location = [53.408937,-2.990781]
    end

    it "should detect my nearest railway station is Liverpool Moorfields" do
      NearestNorthernLineStation.get(@location).should == "MRF"
    end
  end

  context "When I am at home in Crosby" do
    before do
      @location = [53.492921,-3.031698]
    end

    it "should detect my nearest railway station is Crosby" do
      NearestNorthernLineStation.get(@location).should == "BLN"
    end
  end

  context "When I am at shopping in Southport" do
    before do
      @location = [53.642959, -3.013687]
    end

    it "should detect my nearest railway station is Southport" do
      NearestNorthernLineStation.get(@location).should == "SOP"
    end
  end

  context "When I am more than a mile away from any Merseyrail Northern Line station" do
    before do
      @location = [53.479522,-2.23279]
    end

    it "should not detect a station" do
      NearestNorthernLineStation.get(@location).should == nil
    end
  end
end
