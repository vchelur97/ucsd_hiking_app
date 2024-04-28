class HikeCar < ApplicationRecord
  belongs_to :hike
  belongs_to :car
  has_many :participants, class_name: 'HikeParticipant', dependent: :destroy
  store :metadata, accessors: %i[spots_available pickup_time pickup_address compensation note], coder: JSON
end
