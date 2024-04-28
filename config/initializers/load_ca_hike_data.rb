require 'csv'

ca_hike_data_path = Rails.root.join('public', 'California_2024-04-02.csv')
CA_HIKE_DATA = CSV.read(ca_hike_data_path, headers: true).map(&:to_h)
CA_HIKE_MAP = CA_HIKE_DATA.index_by { |row| row['url'] }
