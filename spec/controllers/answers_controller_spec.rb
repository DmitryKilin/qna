require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer)}
  let(:user) { create(:user) }

  before { login(user) }

  describe 'POST #create' do
    context 'With valid attributes ' do
      let(:question) {create(:question)}

      it 'saves a new answer in the database' do
        expect{post :create, params: { question_id: answer.question_id, answer: attributes_for(:answer)  }}.to change(answer.question.answers, :count).by(1)
      end

      it 'saves authored answer with passed attributes' do
        new_answer_attributes = attributes_for(:answer)
        expect {
          post :create, params: { question_id: question, answer: new_answer_attributes }
        }.to change(question.answers, :count).by(1)

        new_answer = question.answers.find_by(new_answer_attributes)
        expect(new_answer).not_to be_nil
        expect(user).to be_author(new_answer)
      end

      it 'redirects to show question which shows the question and its answers' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer)}
        expect(response).to redirect_to answer.question
      end
    end

    context 'with invalid attributes' do
      before { post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) } }

      it 'does not change the answer' do
        expect {response }.to_not change(Answer, :count)
      end
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: answer} }

    it 'renders show view which represents @answer' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer)}

    context 'Authenticated user is the author.' do
      before { login(answer.user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'Authenticated user is not the author.' do
      before { login(user) }

      it "tries delete another's answer" do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
      end
    end
  end
end
