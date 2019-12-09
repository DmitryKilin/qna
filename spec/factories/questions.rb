include ActionDispatch::TestProcess

FactoryBot.define do
  sequence :title do |n|
    "Question № #{n}"
  end

  factory :question do
    title { generate :title }
    body { 'MyText' }
    user

    factory :question_with_answers do
      transient do
        first_ranked { false }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, 2, question: question)
        question.answers.first.update!(ranked: true) if evaluator.first_ranked
      end
    end

    trait :with_attachments do
      files do
        [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb'),
         fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'spec_helper/rb')]
      end
    end

    trait :invalid do
      title { nil }
    end
  end
end
