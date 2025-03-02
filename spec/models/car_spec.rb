require 'rails_helper'

RSpec.describe Car, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:hike_cars) }
  end

  describe 'validations' do
    it { should validate_presence_of(:color) }
    it { should validate_presence_of(:make) }
    it { should validate_presence_of(:model) }
    it { should validate_presence_of(:capacity) }
  end
end
