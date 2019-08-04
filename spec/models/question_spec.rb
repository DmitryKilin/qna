require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user).inverse_of(:questions).required }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :title}
  it { should validate_presence_of :body}

  it { should have_db_column(:praise).of_type(:string)  }

  it { should accept_nested_attributes_for :links }
  it 'have Reward attached file' do
    expect(Question.new.reward).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
