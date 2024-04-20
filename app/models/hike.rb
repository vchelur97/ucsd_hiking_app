class Hike < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :hike_cars, dependent: :destroy
  has_many :hike_participants, through: :hike_cars
  store :stats, accessors: %i[length elevation duration route_type difficulty]
  broadcasts
end
