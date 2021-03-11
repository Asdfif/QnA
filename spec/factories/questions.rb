FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "MyStringQuestion#{n}" }
    sequence(:body)  { |n| "MyTextQuestion#{n}" }

    trait :invalid do
      title { nil }
    end
  end
end
