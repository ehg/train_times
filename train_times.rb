require 'nokogiri'

class TrainTimes
  attr_accessor :current_date
  attr_accessor :parsed

  def fetch(station_code)
    html = ScraperWiki::scrape "http://www.opentraintimes.com/location/#{station_code}/#{current_date.strftime('%Y/%m/%d/%H:%M')}"
    self.parsed = parse html
  end

  def parse(html)
    parsed = []
    doc = Nokogiri::HTML html
    doc.search("table.table tbody tr").each do |row|
      cells = row.search("td")
      parsed << { arrives: cells[1].text, from: cells[2].text }
    end
    parsed
  end

  def find_trains(origin_station)
    self.parsed.collect { |t| calculate_time Time.strptime(t[:arrives], '%H%M') if t[:from] == origin_station }
    .compact.select { |t| t > current_date.to_time + 10 * 60 }[0..1]
  end

  def calculate_time(time)
    Time.mktime current_date.year, current_date.month, current_date.day,
                time.hour, time.min, time.sec
  end
end
