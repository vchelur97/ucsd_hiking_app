class HikeCar < ApplicationRecord
  belongs_to :hike
  belongs_to :car
  has_one :driver, through: :car, source: :user
  has_many :participants, class_name: 'HikeParticipant', dependent: :destroy
  store :metadata, accessors: %i[spots_available pickup_time pickup_address compensation note], coder: JSON

  def spot_available?
    participants.length < spots_available.to_i
  end
end
