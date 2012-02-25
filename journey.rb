require 'nearest_nl_station'
require 'my_location'
require 'train_times'

class Journey
  attr_accessor :train_origin
  attr_accessor :current_date

  def initialize(current_location)
    office = [53.405696, -2.970465]
    home = [53.492921,-3.031698]
    home_miles = NearestNorthernLineStation.distance(current_location, home)
    office_miles = NearestNorthernLineStation.distance(current_location, office)
    self.train_origin = "Southport" if home_miles < office_miles
    self.train_origin = "Hunts Cross" if office_miles < home_miles
    @nearest_station = NearestNorthernLineStation.get(current_location)
  end

  def next_trains()
    times = TrainTimes.new @nearest_station
    times.current_date = self.current_date
    times.fetch @nearest_station # coupled
    times.find_trains self.train_origin
  end
end
