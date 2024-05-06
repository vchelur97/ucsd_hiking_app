class HikeParticipant < ApplicationRecord
  belongs_to :hike_car
  belongs_to :user
  store :metadata, accessors: %i[note], coder: JSON
end
