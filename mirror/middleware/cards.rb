require "sinatra/base"
require "slim"

module Mirror
  module Middleware
    class Cards < Sinatra::Base
      helpers Mirror::SessionsHelper
      use Mirror::Middleware::OAuth
      set :views, -> { Mirror.root.join("mirror/views").to_s }

      get "/cards/new" do
        slim :"cards/new"
      end

      post "/cards" do
        client = Mirror::Client.new(access_token: current_user.access_token)
        card = Mirror::Card.new(params[:card])
        client.insert_card(card)
        redirect to "/"
      end
    end
  end
end
