require "pathname"

module Mirror
  def self.root
    Pathname.new(__FILE__).dirname
  end
end

require "./config/environment"
require "./mirror/models/client"
require "./mirror/models/user"
require "./mirror/models/card"
require "./mirror/helpers/application_helper"
require "./mirror/application"
