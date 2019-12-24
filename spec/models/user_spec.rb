require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).class_name('Question').inverse_of(:user) }
  it { should have_many(:answers).class_name('Answer').inverse_of(:user) }
  it { should have_many(:prizes).inverse_of(:user) }
  it { should have_many(:authorizations).inverse_of(:user).dependent(:destroy) }
  it { should have_many(:subscriptions).inverse_of(:user).dependent(:destroy) }
  it { should have_many(:subscribed_questions).through(:subscriptions) }

  let(:user) { create(:user) }

  describe '#author?' do
    it { is_expected.to respond_to(:author?) }

    it 'true if user and author of the question are the same' do
      question = user.questions.new(attributes_for(:question))
      expect(user).to be_author(question)
    end

    it 'true if user and author of the answer are the same' do
      answer = user.answers.new(attributes_for(:answer))
      expect(user).to be_author(answer)
    end

    it 'false if user and author of the question are not the same ' do
      question = create(:question)
      expect(user).not_to be_author(question)
    end

    it 'false if user and author of the answer are not the same' do
      answer = create(:answer)
      expect(user).not_to be_author(answer)
    end
  end
  describe '#attachment_owner?' do
    it 'true if user is the owner of attachments' do
      question = user.questions.create(attributes_for(:question, :with_attachments))
      expect(user).to be_attachment_owner(question.files.first)
    end

    it 'false if user NOT the owner of attachments' do
      question = create(:question, :with_attachments)
      expect(user).not_to be_attachment_owner(question.files.first)
    end
  end
  describe '.find_for_auth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'call Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
  describe '#subscribed_to?' do
    let(:question) { create :question, user: user }
    let!(:subscription) { create :subscription, user: user, question: question }
    let(:other_user) { create :user }

    it 'true if subscribed' do
      expect(user).to be_subscribed_to(question)
    end

    it 'false if NOT subscribed' do
      expect(other_user).to_not be_subscribed_to(question)
    end
  end
  describe '#subscription_for' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: user, question: question) }
    it 'returns subscription ' do
      expect(user.subscription_for(question)).to eq subscription
    end
  end
end
