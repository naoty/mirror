require "sinatra/base"
require "slim"

module Mirror
  class Application < Sinatra::Base
    helpers Mirror::SessionsHelper
    set :public_folder, Mirror.root.join("public").to_s
    use Rack::Session::Cookie, expire_after: 3600, secret: ""

    # Middlewares
    use Mirror::Middleware::Cards

    get "/" do
      slim :index
    end
  end
end
