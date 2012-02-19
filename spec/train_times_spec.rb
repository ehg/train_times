require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../train_times.rb'
require File.dirname(__FILE__) + '/../nearest_nl_station.rb'
require File.dirname(__FILE__) + '/../detect_location.rb'

WebMock.allow_net_connect!

describe TrainTimes do
  context "When I'm at home and the closest station to me is Crosby and it's 8:10am" do
    before do
      NearestNorthernLineStation.expects(:get).returns('BLN')
      # DetectLocation should be called TrainDetect or something
      DetectLocation.expects(:origin_station).returns('Southport')
      DetectLocation.expects(:destination_station).returns('Hunts Cross')
      @station_code = NearestNorthernLineStation.get([0,0])
      @origin = DetectLocation.origin_station
      @destination = DetectLocation.destination_station
      @train_times = TrainTimes.new
      @train_times.current_date = DateTime.new(2012, 02, 20, 8, 10)
      @train_times.fetch(@station_code)
    end

    it "should fetch the opentraintimes page for the current time" do
      a_request(:get, "http://www.opentraintimes.com/location/BLN/2012/02/20/08:10").should have_been_made
    end

    it "should parse the train times" do
      @train_times.parsed.length.should > 2
    end

    it "should return the next two trains to liverpool central after 8:10 + 10m" do
      trains = @train_times.find_trains(@origin)
      p trains
      trains.length.should == 2
      trains.first.should be_a_kind_of Time
      trains.first.should > @train_times.calculate_time(Time.strptime('0820', '%H%M'))
    end
  end
end
