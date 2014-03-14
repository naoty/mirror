require "sinatra/base"

module Mirror
  module Middleware
    class OAuth < Sinatra::Base
      helpers Mirror::SessionsHelper

      get "/oauth" do
        client = Mirror::Client.new

        # Step 1 of the OAuth 2.0
        # Redirect to Google
        redirect to client.authorization_url(user_id: nil, state: nil)
      end

      get "/oauth/callback" do
        client = Mirror::Client.new

        # Step 2 of the OAuth 2.0
        # Exchange an authorization code for an access token
        access_token = client.exchange_code_for_access_token(params[:code])

        # Save user and signin
        user_id = client.userinfo.id
        user = User.find_by(uid: user_id) || User.new(uid: user_id)
        user.access_token = access_token
        user.save
        sign_in(user)

        redirect to "/"
      end

      get "/signout" do
        sign_out
        redirect to "/"
      end
    end
  end
end
