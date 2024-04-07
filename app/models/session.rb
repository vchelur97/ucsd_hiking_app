class Session < ApplicationRecord
  belongs_to :user

  validates :push_endpoint, presence: true, uniqueness: true, on: :update
  validates :push_p256dh, presence: true, on: :update
  validates :push_auth, presence: true, on: :update
end
