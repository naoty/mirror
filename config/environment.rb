require "uri"
require "sinatra"
require "sinatra/activerecord"

configure :development, :test do
  set :database_file, Mirror.root.join("config/database.yml").to_s
end

configure :production do
  # Setup for Heroku postgresql
  db = URI.parse(ENV["DATABASE_URL"] || "postgres://localhost/mydb")
  ActiveRecord::Base.establish_connection(
    adapter:  db.scheme == "postgres" ? "postgresql" : db.scheme,
    host:     db.host,
    username: db.user,
    password: db.password,
    database: db.path[1..-1],
    encoding: "utf8"
  )
end
