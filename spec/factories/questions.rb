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
      reward {fixture_file_upload(Rails.root.join('spec/fixtures/files', 'image.jpg'), 'image/jpeg')}
      praise {'You are the Star'}
    end

    trait :with_attachments do
      files
      reward
      praise
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
