FactoryBot.define do
  factory :comment do
    body { "MyCommentBody" }

    trait :invalid do
      body { nil }
    end
  end
end
