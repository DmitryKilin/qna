FactoryBot.define do
  sequence :title do |n|
    "Question № #{n}"
  end

  factory :question do
    title {'MyString'}
    body {'MyText'}
    user

    trait :with_answers do
      answers  {create_list(:answer, 3)}
    end

    trait :invalid do
      title { nil }
    end

    trait :sequence do
      title
      body {"Question Text"}
    end
    #
    # trait :with_authorship do
    #   user
    # end
  end
end
