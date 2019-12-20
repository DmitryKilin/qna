FactoryBot.define do
  factory :link do
    name { 'Google' }
    url { 'https://google.ru' }
    trait :gist do
      url { 'https://gist.github.com/DmitryKilin/0f6260bee40dac34d43ecc48caa06913' }
    end
  end
end