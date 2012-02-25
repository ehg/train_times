require 'nearest_nl_station'

class Journey
  attr_accessor :train_origin

  def initialize(current_location)
    office = [53.405696, -2.970465]
    home = [53.492921,-3.031698]
    home_miles = NearestNorthernLineStation.distance(current_location, home)
    office_miles = NearestNorthernLineStation.distance(current_location, office)
    self.train_origin = "Southport" if home_miles < office_miles
    self.train_origin = "Hunts Cross" if office_miles < home_miles
  end
end
