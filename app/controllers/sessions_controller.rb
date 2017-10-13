class SessionsController < ApplicationController

  skip_before_action :authenticate_user, only: :create

  # Foursquare redirects users with a code that can be accessed through params and exchanged for an access token with a second GET request. We'll need to provide our ID, secret, and the code we just got.

  def create
  resp = Faraday.get("https://foursquare.com/oauth2/access_token") do |req|
    req.params['client_id'] = ENV['FOURSQUARE_CLIENT_ID']
    req.params['client_secret'] = ENV['FOURSQUARE_SECRET']
    req.params['grant_type'] = 'authorization_code'
    req.params['redirect_uri'] = "http://localhost:3000/auth"
    req.params['code'] = params[:code]
  end

  body = JSON.parse(resp.body)
  session[:token] = body["access_token"]
  redirect_to root_path
end

end
