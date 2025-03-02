FactoryBot.define do
  factory :user do
    uid { SecureRandom.uuid }
    email { Faker::Internet.email(domain: 'ucsd.edu') }
    full_name { Faker::Name.name }
    avatar_url { Faker::Internet.url }

    trait :with_details do
      preferred_name { Faker::Name.first_name }
      phone_no { Faker::Number.number(digits: 10).to_s }
      discord { "#{Faker::Internet.username}##{Faker::Number.number(digits: 4)}" }
    end

    trait :hiker do
      roles { ['hiker'] }
    end

    trait :admin do
      roles { %w[hiker board admin] }
    end

    trait :with_non_ucsd_email do
      email { Faker::Internet.email(domain: 'gmail.com') }
    end

    trait :with_car do
      after(:create) do |user|
        create(:car, user: user)
      end
    end

    trait :with_signed_waiver do
      after(:create) do |user|
        create(:waiver, user: user)
      end
    end
  end
end
