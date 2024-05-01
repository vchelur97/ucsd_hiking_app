class Car < ApplicationRecord
  belongs_to :user
  has_many :hike_cars
  validates :color, :make, :model, :license_plate, :capacity, presence: true
end
