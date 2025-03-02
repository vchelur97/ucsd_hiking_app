require 'rails_helper'

RSpec.describe HikeCar, type: :model do
  describe 'associations' do
    it { should belong_to(:hike) }
    it { should belong_to(:car) }
    it { should have_one(:driver).through(:car).source(:user) }
    it { should have_many(:participants).class_name('HikeParticipant').dependent(:destroy) }
  end

  describe 'stored attributes' do
    it 'has metadata accessors' do
      hike_car = build(:hike_car)
      metadata_fields = %i[spots_available pickup_time pickup_address compensation note]
      metadata_fields.each do |field|
        expect(hike_car).to respond_to(field)
        expect(hike_car).to respond_to("#{field}=")
      end
    end
  end

  describe '#spot_available?' do
    it 'returns true when spots are available' do
      hike_car = create(:hike_car, metadata: { spots_available: 3 })
      create(:hike_participant, hike_car: hike_car)
      expect(hike_car.reload).to be_spot_available
    end

    it 'returns false when all spots are taken' do
      hike_car = create(:hike_car, metadata: { spots_available: 3 })
      create_list(:hike_participant, 3, hike_car: hike_car)
      expect(hike_car.reload).not_to be_spot_available
    end
  end
end
