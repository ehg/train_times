require 'scraperwiki'

class MyLocation
  def self.get()
    resp = ScraperWiki::scrape "https://www.googleapis.com/latitude/v1/currentLocation?access_token=ya29.AHES6ZTAopvT9afArXatUhJluLNl7g1AWoYwkDCjpn040P0HlsEZfw&granularity=best"
    parsed = JSON.parse(resp)['data']
    [parsed['latitude'].to_f, parsed['longitude'].to_f]
  end
end
