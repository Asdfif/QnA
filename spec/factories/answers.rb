FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "MyTextAnswer#{n}" }

    trait :invalid do
      body { nil }
    end
  end
end
