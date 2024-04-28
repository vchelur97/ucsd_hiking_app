module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :user

    def connect
      self.user = find_verified_user
    end

    private

    def find_verified_user
      session = Session.find_by(id: cookies.signed[:session_id])
      cookies.delete(:session_id) unless session
      if (user = session&.user)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
