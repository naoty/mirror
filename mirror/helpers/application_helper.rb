module Mirror
  module ApplicationHelper
    def sign_in(user)
      remember_token = User.new_remember_token
      session[:remember_token] = remember_token
      user.update_attributes(remember_token: User.encrypt(remember_token))
      self.current_user = user
    end

    def sign_out
      self.current_user = nil
      session.delete(:remember_token)
    end

    def signed_in?
      !!current_user
    end

    def current_user=(user)
      @current_user = user
    end

    def current_user
      remember_token = User.encrypt(session[:remember_token])
      @current_user ||= User.find_by(remember_token: remember_token)
    end
  end
end
