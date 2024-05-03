class Hike < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :hike_cars, dependent: :destroy
  has_many :hike_participants, through: :hike_cars, source: :participants
  has_one_attached :graphic
  store :stats, accessors: %i[length elevation duration route_type difficulty], coder: JSON
end
