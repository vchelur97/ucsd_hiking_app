class HikeCar < ApplicationRecord
  belongs_to :hike
  belongs_to :car
  store :metadata, accessors: %i[spot_info pickup_info]
  broadcasts_to :hike
end
