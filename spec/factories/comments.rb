include ActionDispatch::TestProcess

FactoryBot.define do
  factory :comment do
    body {'New Comment'}
    user

    trait :invalid do
      body { '' }
    end
  end
end
