FactoryBot.define do
  factory :answer do
    body { "MyTextAnswer" }

    trait :invalid do
      body { nil }
    end
  end
end
