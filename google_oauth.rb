require 'rest_client'
require 'json'

class GoogleOAuth
  def self.authorise()
    resp = RestClient.post 'https://accounts.google.com/o/oauth2/device/code', 
      :client_id => '344903981192.apps.googleusercontent.com',
      :scope => 'https://www.googleapis.com/auth/latitude.current.best'
    JSON.parse resp.to_str
  end

  def self.get_tokens(device_code)
    resp = RestClient.post 'https://accounts.google.com/o/oauth2/token',
      :client_id => '344903981192.apps.googleusercontent.com',
      :client_secret => 'JybihFWQrtxtU7ay9DyupV6q',
      :code => device_code,
      :grant_type => 'http://oauth.net/grant_type/device/1.0'
    JSON.parse resp.to_str
  end
end
