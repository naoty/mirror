require "digest"
require "securerandom"

class User < ActiveRecord::Base

  before_create :initialize_remember_token

  def self.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  private

  def initialize_remember_token
    self.remember_token = User.encrypt(User.new_remember_token)
  end

end
