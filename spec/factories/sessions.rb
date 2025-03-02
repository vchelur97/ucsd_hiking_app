FactoryBot.define do
  factory :session do
    association :user

    trait :with_push_endpoint do
      push_endpoint { "https://fcm.googleapis.com/fcm/send/#{SecureRandom.hex(16)}" }
      push_p256dh { SecureRandom.base64(32) }
      push_auth { SecureRandom.base64(16) }
    end

    trait :without_push_endpoint do
      push_endpoint { nil }
      push_p256dh { nil }
      push_auth { nil }
    end
  end
end
