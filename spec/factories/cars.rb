FactoryBot.define do
  factory :car do
    association :user
    make { Faker::Vehicle.make }
    model { |car| Faker::Vehicle.model(make_of_model: car.make) }
    color { Faker::Vehicle.color }
    capacity { Faker::Number.between(from: 2, to: 8) }
    license_plate { Faker::Vehicle.license_plate }
    mpg { Faker::Number.decimal(l_digits: 2, r_digits: 1).to_f }
  end
end
