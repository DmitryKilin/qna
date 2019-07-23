require 'rails_helper'

RSpec.describe User, type: :model do
  it {should validate_presence_of :email}
  it {should validate_presence_of :password}
  it { should have_many(:questions).class_name('Question').inverse_of(:user) }
  it { should have_many(:answers).class_name('Answer').inverse_of(:user) }
  
  describe  '#author?'do
    let(:user) {create(:user)}

    it { is_expected.to respond_to(:author?) }

    it "true if user and author of the question are the same" do
      question = user.questions.new(attributes_for(:question))
      expect(user).to be_author(question)
    end

    it "true if user and author of the answer are the same" do
      answer = user.answers.new(attributes_for(:answer))
      expect(user).to be_author(answer)
    end

    it "false if user and author of the question are not the same " do
      question = create(:question)
      expect(user).not_to be_author(question)
    end

    it "false if user and author of the answer are not the same" do
      answer = create(:answer)
      expect(user).not_to be_author(answer)
    end
  end

end
