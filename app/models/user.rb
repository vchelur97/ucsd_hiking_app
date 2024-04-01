class User < ApplicationRecord
  def self.from_omniauth(auth)
    where(email: auth.email).first_or_create do |user|
      user.email = auth.info.email
      user.full_name = auth.info.name # assuming the user model has a name
      user.avatar_url = auth.info.image # assuming the user model has an image
    end
  end
end
