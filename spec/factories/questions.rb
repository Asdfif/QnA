FactoryBot.define do
  factory :question do
    title { "MyStringQuestion" }
    body { "MyTextQuestion" }

    trait :invalid do
      title { nil }
    end
  end
end
