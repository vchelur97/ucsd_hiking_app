class Hike < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :hike_cars, dependent: :destroy
  has_many :hike_participants, through: :hike_cars, source: :participants
  has_one_attached :graphic
  store :stats, accessors: %i[length elevation duration route_type difficulty], coder: JSON

  validates :title, :length, :elevation, :duration, :route_type, :difficulty, :description, :date,
            :time, :trailhead_address, :suggested_items, presence: true, unless: :draft?

  validates :short_description, :graphic, presence: true, if: :published?

  def date
    datetime&.to_date&.strftime('%B %d %A')
  end

  def time
    datetime&.strftime('%I:%M %p')
  end

  def published?
    status == 'published'
  end

  def draft?
    status == 'draft'
  end

  def review?
    status == 'review'
  end
end
