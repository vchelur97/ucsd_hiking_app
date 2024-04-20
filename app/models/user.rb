class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :waivers, dependent: :destroy
  has_many :cars, dependent: :destroy
  has_many :hikes, foreign_key: :host_id, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  validates :phone_no, presence: true, format: { with: /\A\d{10}\z/ }, on: :update

  def self.create_from_omniauth(auth)
    user = find_by(email: auth.info.email)
    first_time = user.nil?
    user ||= create(email: auth.info.email, full_name: auth.info.name, avatar_url: auth.info.image)
    if user.avatar_url.nil?
      update(user.id, email: auth.info.email, full_name: auth.info.name, avatar_url: auth.info.image)
    end
    [user, first_time]
  end

  def admin?
    roles.include?("admin") || roles.include?("board")
  end

  def host?(hike)
    id == hike.host.id
  end
end
