class Car < ApplicationRecord
  belongs_to :user
  validates :color, :make, :model, :license_plate, :capacity, presence: true
end
