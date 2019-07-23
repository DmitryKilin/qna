FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    ranked { false }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :ranked_true do
      ranked { true }
    end
  end
end
