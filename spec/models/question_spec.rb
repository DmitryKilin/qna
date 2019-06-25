require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:delete_all) }
  it { should belong_to(:author).class_name('User').inverse_of(:authorships).required }
  it { should validate_presence_of :title}
  it { should validate_presence_of :body}
end
