FactoryBot.define do
  sequence :title do |n|
    "Question № #{n}"
  end

  factory :question do
    title {'MyString'}
    body {'MyText'}

    trait :with_answers do
      answers  {create_list(:answer, 5)}
    end

    trait :invalid do
      title { nil }
    end

    trait :sequence do
      title
      body {"Question Text"}
    end

    trait :with_authorship do
      association :author, factory: :user
    end
  end
end
