require 'rest_client'
class Dailymile
  include HTTParty
  base_uri 'https://api.dailymile.com'

  def post_gpx(runkeeper_url, dailymile_url, user)
    put_url = 'https://api.dailymile.com/entries/#{id}/track.json?oauth_token='
    gpx_data = string
    content_type = 'application/gpx+xml'

  end
end
