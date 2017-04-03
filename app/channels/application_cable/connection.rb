module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end 

    protected
    def find_verified_user
      puts "------------------- HERE ------------------------"
      puts cookies
      puts "-------------------------------------------------"
      # if current_user = User.find_by(id: cookies.signed[:user_id])
      if current_user = User.find_by_remember_me_token(cookies[:remember_me_token])
        current_user
      else
        reject_unauthorized_connection
      end 
    end 
  end 
end
