include ActionDispatch::TestProcess

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

    trait :with_attachments do
      files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb')] }
    end

    trait :invalid do
      title { nil }
    end

    trait :sequence do
      title
      body {"Question Text"}
    end
  end
end
