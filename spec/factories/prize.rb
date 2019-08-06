include ActionDispatch::TestProcess

FactoryBot.define do
  factory :prize do
    praise {'You are good!'}
    reward {fixture_file_upload(Rails.root.join('spec/fixtures/files', 'image.jpg'), 'image/jpeg')}
  end
end