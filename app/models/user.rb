class User < ApplicationRecord
  has_many :sessions

  def self.create_from_omniauth(auth)
    user = find_by(email: auth.info.email)
    first_time = user.nil?
    user ||= create(email: auth.info.email, full_name: auth.info.name, avatar_url: auth.info.image)
    [user, first_time]
  end
end
