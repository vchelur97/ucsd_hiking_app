class Waiver < ApplicationRecord
  LATEST_VERSION = 1

  belongs_to :user

  validates :version, presence: true, inclusion: { in: 1..LATEST_VERSION }
  validates :user, presence: true
end
