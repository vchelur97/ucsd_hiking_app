class Hike < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :hike_cars, dependent: :destroy
  store :stats, accessors: %i[length elevation duration route_type difficulty]
  broadcasts
end
