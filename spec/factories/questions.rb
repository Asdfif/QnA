FactoryBot.define do
  sequence :title do |n|
    "MyStringQuestion#{n}"
  end

  sequence :body do |n|
    "MyTextQuestion#{n}"
  end

  factory :question do
    title { "MyStringQuestion" }
    body { "MyTextQuestion" }

    trait :invalid do
      title { nil }
    end
  end
end
