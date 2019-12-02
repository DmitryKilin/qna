require 'rails_helper'

describe 'Ability' do
  subject(:ability) { Ability.new(user) }

  context ' for quest.' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  context ' for admin.' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to :manage, :all }
  end

  context ' for user.' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    describe ' Common abilities.' do
      it { should_not be_able_to :manage, :all }
      it { should be_able_to :read, :all }
    end
    describe ' Ability create.' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end
    describe ' Ability update.' do
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other), user: user }

      it { should be_able_to :update, create(:answer, user: user), user: user }
      it { should_not be_able_to :update, create(:answer, user: other), user: user }

      it {
        should be_able_to :update, create(:comment, :comment_question, user: user),
                        user: user
      }
      it {
       should_not be_able_to :update, create(:comment, :comment_question, user: other),
                            user: user
      }

      end
    describe ' Ability destroy.' do
      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question) }
      it { should be_able_to :destroy, create(:answer, user: user) }
      it { should_not be_able_to :destroy, create(:answer) }
      it {
        should be_able_to :destroy, create(:comment, :comment_question, user: user),
                        user: user
      }
      it {
        should_not be_able_to :destroy, create(:comment, :comment_question, user: other),
                            user: user
      }
    end
    describe ' Ability manage attachments' do
      let(:question) { create(:question, :with_attachments, user: user) }
      let(:question2) { create(:question, :with_attachments) }
      let(:answer) { create(:question, :with_attachments, user: user) }
      let(:answer2) { create(:question, :with_attachments) }

      it { should be_able_to :create, question.files.new }
      it { should be_able_to :destroy, question.files.last }
      it { should_not be_able_to :create, question2.files.new }
      it { should_not be_able_to :destroy, question2.files.last }

      it { should be_able_to :create, answer.files.new }
      it { should be_able_to :destroy, answer.files.last }
      it { should_not be_able_to :create, answer2.files.new }
      it { should_not be_able_to :destroy, answer2.files.last }
    end
    describe ' Ability to vote' do
      it { should_not be_able_to :vote_up, create(:answer, user: user) }
      it { should be_able_to :vote_up, create(:answer) }
      it { should_not be_able_to :vote_down, create(:answer, user: user) }
      it { should be_able_to :vote_down, create(:answer) }


      it { should_not be_able_to :vote_up, create(:question, user: user) }
      it { should be_able_to :vote_up, create(:question) }
      it { should_not be_able_to :vote_down, create(:question, user: user) }
      it { should be_able_to :vote_down, create(:question) }
    end
    describe ' Ability manage links' do
      let(:question) { create(:question, user: user) }
      let(:question2) { create(:question) }
      let!(:answer) { create(:answer, user: user) }
      let!(:answer2) { create(:answer) }

      it { should be_able_to :create, question.links.new }
      it { should_not be_able_to :create, question2.links.new }
      it { should be_able_to :create, answer.links.new }
      it { should_not be_able_to :create, answer2.links.new }
    end
    describe ' Ability to create rewards for question' do
      let(:question) { create(:question, user: user) }
      let(:question2) { create(:question) }
      it { should be_able_to :create, create(:prize, question: question) }
      it { should_not be_able_to :create, create(:prize, question: question2) }
    end
  end
end
