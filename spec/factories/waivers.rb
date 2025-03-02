FactoryBot.define do
  factory :waiver do
    association :user
    ip_address { Faker::Internet.ip_v4_address }
    user_agent do
      "Mozilla/5.0 (#{['Windows NT 10.0', 'Macintosh',
                       'Linux'].sample}; #{%w[Chrome Firefox Safari].sample}/#{rand(70..100)}.0)"
    end
    version { 1 }

    trait :outdated do
      version { 0 }
    end
  end
end
