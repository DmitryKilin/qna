require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).class_name('Question').inverse_of(:user) }
  it { should have_many(:answers).class_name('Answer').inverse_of(:user) }
  it { should have_many(:prizes).inverse_of(:user) }

  describe '#author?' do
    let(:user) { create(:user) }

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
  describe '#attachment_owner?' do
    let(:user) { create(:user) }

    it "true if user is the owner of attachments" do
      question = user.questions.create(attributes_for(:question, :with_attachments))
      expect(user).to be_attachment_owner(question.files.first)
    end

    it "false if user NOT the owner of attachments" do
      question = create(:question, :with_attachments)
      expect(user).not_to be_attachment_owner(question.files.first)
    end

  end
  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    context 'User already has authorization.' do
      it 'returns user.' do
        user.authorizations.create(provider: 'github', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq(user)
      end
    end
    context 'User NOT to have authorization.' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }

        it 'does NOT create new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'create a new kind of authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq(user)
        end
      end
    end
    context 'User does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }

      it 'creates new user' do
        expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end
      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end
      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq(auth.info[:email])
      end
      it 'creates authorization for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end
      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

  end
end
