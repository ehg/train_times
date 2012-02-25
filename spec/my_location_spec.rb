require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../my_location.rb'

WebMock.allow_net_connect!

describe MyLocation do
  use_vcr_cassette 'requests'

  before do
    @location = MyLocation.get
  end

  it "gets my current location from the Latitude API" do
    a_request(:get, "https://www.googleapis.com/latitude/v1/currentLocation?access_token=ya29.AHES6ZTAopvT9afArXatUhJluLNl7g1AWoYwkDCjpn040P0HlsEZfw&granularity=best").should have_been_made
  end

  it "should parse the latitude and longitude" do
    @location.should_not be_nil
    @location[0].should_not be_nil
    @location[0].should be_a_kind_of Numeric
    @location[1].should_not be_nil
    @location[1].should be_a_kind_of Numeric
  end
end
