FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :with_answers do
      answers  {create_list(:answer, 5)}
    end

    trait :invalid do
      title { nil }
    end
  end
end
