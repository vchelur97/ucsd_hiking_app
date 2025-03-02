FactoryBot.define do
  factory :hike_car do
    # Simple associations
    association :car
    association :hike, factory: %i[hike draft] # Use draft to minimize validations

    # Default metadata
    metadata do
      {
        spots_available: 4,
        pickup_time: '9:00 AM',
        pickup_address: '123 Test St',
        compensation: '10.00',
        note: 'Test note'
      }
    end

    # Explicit traits for specific states
    trait :with_spots do
      transient do
        spots_count { 4 }
      end

      metadata do
        {
          spots_available: spots_count,
          pickup_time: '9:00 AM',
          pickup_address: '123 Test St'
        }
      end
    end

    trait :full do
      with_spots
      after(:create) do |hike_car|
        available_spots = hike_car.metadata['spots_available'].to_i
        available_spots.times do
          create(:hike_participant, hike_car: hike_car)
        end
        hike_car.reload
      end
    end

    trait :empty do
      with_spots
    end

    trait :with_invalid_spots do
      metadata { { spots_available: nil } }
    end
  end
end
