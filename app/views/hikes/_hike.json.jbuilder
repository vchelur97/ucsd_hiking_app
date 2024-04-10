json.extract! hike, :id, :title, :description, :date, :time, :user_id, :length, :elevation, :route_type, :duration, :trailhead_address, :alltrails_link, :suggested_items, :driver_compensation_type, :notes, :metadata, :created_at, :updated_at
json.url hike_url(hike, format: :json)
