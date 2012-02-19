require 'scraperwiki'

class NearestNorthernLineStation
  def self.fetch_stations()
    response = ScraperWiki.scrape "https://api.scraperwiki.com/api/1.0/datastore/sqlite?format=jsondict&name=stationsmerseyrail&query=SELECT%20Code%2C%20%5Bstation%20name%5D%2C%20latlng%20from%20%60swdata%60%20WHERE%20Lines%20LIKE%20'%25Northern%20Line%25'"
    parsed = JSON.parse response.to_str
    stations = {}
    pattern = /\('(?<lat>.+)', '(?<lng>.+)'\)/
    parsed.each do |s| 
      match = pattern.match(s['latlng'])
      stations[s['Code']] = {name: s['station name'], latitude: match[:lat].to_f, longitude: match[:lng].to_f}
    end
    stations
  end

  def self.stations()
    @stations = fetch_stations
  end
  
  def self.get(location)
    distances = {}
    @stations.each do |k, v|
      distances[k] = distance(location, [v[:latitude], v[:longitude]])
    end
    sorted = distances.sort_by {|k,v| v}
    return nil if sorted.first.last > 1
    sorted.first.first
  end
  
  # http://www.movable-type.co.uk/scripts/latlong.html
  # loc1 and loc2 are arrays of [latitude, longitude]
  def self.distance(loc1, loc2)
    lat1, lon1 = loc1
    lat2, lon2 = loc2
    dLat = (lat2-lat1).to_rad;
    dLon = (lon2-lon1).to_rad;
    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(lat1.to_rad) * Math.cos(lat2.to_rad) *
      Math.sin(dLon/2) * Math.sin(dLon/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    d = 3960 * c; # Multiply by 3960 to get Miles
  end
end

class Numeric
  def to_rad
    self * Math::PI / 180
  end
end


