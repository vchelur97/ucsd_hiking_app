class Hike < ApplicationRecord
  belongs_to :host, class_name: 'User'
  store :stats, accessors: %i[length elevation duration route_type difficulty]
end
