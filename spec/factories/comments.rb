FactoryBot.define do
  factory :comment do
    body { 'New Comment' }
    user

    trait :invalid do
      body { '' }
    end

    trait :comment_question do
      commentable { create(:question) }
    end
  end
end
