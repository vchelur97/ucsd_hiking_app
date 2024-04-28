class HikeParticipant < ApplicationRecord
  belongs_to :hike_car
  belongs_to :user
end
