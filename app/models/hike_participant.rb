class HikeParticipant < ApplicationRecord
  belongs_to :hike_car
  belongs_to :user
  belongs_to :hike, through: :hike_car
end
