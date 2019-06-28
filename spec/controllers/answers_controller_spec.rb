require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer)}
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer)  } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question which shows the question and its answers' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }

      it 'does not change the answer' do
        expect {response }.to_not change(Answer, :count)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer} }

    it 'assigns the requested question to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view which represents @answer' do
      expect(response).to render_template :show
    end
  end
end
