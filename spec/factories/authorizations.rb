FactoryBot.define do
  factory :authorization do
    user
    provider { "OAuthProvider" }
    uid { "OAuthUID" }
    confirmation_code { nil }

    trait :have_to_confirm do
      confirmation_code {'123456'}
    end

  end
end
