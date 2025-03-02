FactoryBot.define do
  factory :hike_participant do
    association :user
    association :hike_car

    # Store basic metadata
    metadata do
      {
        note: 'Basic note'
      }
    end
  end
end
