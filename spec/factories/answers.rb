include ActionDispatch::TestProcess

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
      body { "Ranked answer" }
    end

    trait :with_attachments do
      files {fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb')}
    end
  end
end
