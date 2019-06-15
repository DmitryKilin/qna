require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer)}
  let(:question) { create(:question) }


  describe 'GET #new' do
    before {get :new, params: {question_id: question} }

    it 'assigns a new Answer into @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view which represents @question' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      # it 'redirects to show view' do
      #   post :create, params: { question: attributes_for(:question) }
      #   expect(response).to redirect_to assigns(:question)
      #
    end

    context 'with invalid attributes' do
      it 'does not change the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end
    end
  end

end
