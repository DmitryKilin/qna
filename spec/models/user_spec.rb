require 'rails_helper'

RSpec.describe User, type: :model do
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it { should have_many(:questions).class_name('Question').inverse_of(:user) }
  it { should have_many(:answers).class_name('Answer').inverse_of(:user) }

# Нужен юнит-тест на этот метод.
  it { is_expected.to respond_to(:author?) }

  it "creates user and relative question, then checks user 'author?' method returns true." do
    user = create(:user)
    question = user.questions.new(attributes_for(:question))
    expect(user.author?(question)).to be_truthy
  end

  it "creates user and relative answer, then checks user 'author?' method returns true." do
    user = create(:user)
    answer = user.answers.new(attributes_for(:answer))
    expect(user.author?(answer)).to be_truthy
  end
end
