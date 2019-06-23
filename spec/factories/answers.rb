FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    question

    trait :invalid do
      body { nil }
    end
  end
end
