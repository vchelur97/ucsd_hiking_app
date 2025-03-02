FactoryBot.define do
  factory :hike do
    association :host, factory: :user
    title { "#{Faker::Mountain.name} Hike" }
    description { Faker::Lorem.paragraphs(number: 2).join("\n") }
    short_description { Faker::Lorem.sentence }
    trailhead_address { "https://maps.google.com/leopoldo" }
    datetime { Faker::Time.forward(days: 14) }
    suggested_items { ["Water", "Snacks", "Hiking boots"].to_json }
    length { Faker::Number.decimal(l_digits: 2) }
    elevation { Faker::Number.between(from: 100, to: 3000) }
    duration { Faker::Number.between(from: 1, to: 8) }
    route_type { ["Loop", "Out & Back", "Point to Point"].sample }
    difficulty { Faker::Number.between(from: 1, to: 5) }
    alltrails_link { Faker::Internet.url(host: 'alltrails.com') }
    driver_compensation_type { %w[ucsd manual].sample }
    notes { Faker::Lorem.paragraph }
    hike_type { %w[official community colab].sample }
    graphic { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.png'), 'image/png') }
    status { 'draft' }
    subscribers { [] }

    trait :draft do
      status { "draft" }
    end

    trait :published do
      status { "published" }
      short_description { Faker::Lorem.sentence }
      after(:build) do |hike|
        unless hike.graphic.attached?
          hike.graphic.attach(
            io: StringIO.new("test image content"),
            filename: 'test.jpg',
            content_type: 'image/jpeg'
          )
        end
      end
    end

    trait :review do
      status { "review" }
      after(:build) do |hike|
        unless hike.graphic.attached?
          hike.graphic.attach(
            io: StringIO.new("test image content"),
            filename: 'test.jpg',
            content_type: 'image/jpeg'
          )
        end
      end
    end

    trait :with_participants do
      after(:create) do |hike|
        create_list(:hike_car, 2, hike: hike) do |hike_car|
          create_list(:hike_participant, 3, hike_car: hike_car)
        end
      end
    end

    trait :with_cars do
      after(:create) do |hike|
        create_list(:hike_car, 2, hike: hike)
      end
    end
  end
end
