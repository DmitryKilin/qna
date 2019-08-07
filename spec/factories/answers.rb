include ActionDispatch::TestProcess

FactoryBot.define do
  sequence(:body) { |n| "answer body #{n}" }

  factory :answer do
    body {generate (:body)}
    ranked { false }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attachments do
      files {fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb')}
    end
  end
end
