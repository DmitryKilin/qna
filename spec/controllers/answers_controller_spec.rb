require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer)}
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'Unauthenticated user ' do
      let(:question) {create(:question)}
      let(:new_answer_attributes) {attributes_for(:answer)}

      it 'sugested to authenticate.' do
        post :create, params: {question_id: question, answer: new_answer_attributes  }
        expect(response).to redirect_to new_user_session_path
      end

      it "doesn't change the count of the question answers" do
        expect{ post :create, params: {question_id: question, answer: new_answer_attributes } }.not_to change(question.answers, :count)
      end
    end

    context 'With valid attributes ' do
      let(:question) {create(:question)}
      before { login(user) }

      it 'saves a new answer in the database' do
        expect{post :create, params: {question_id: question, answer: attributes_for(:answer)} ,format: :js}.to change(question.answers, :count).by(1)
      end

      it 'saves authored answer with attachment' do
        new_answer_attributes = attributes_for(:answer, :with_attachments)
        new_body = new_answer_attributes[:body]

        expect {
          post :create, params: {question_id: question, answer: new_answer_attributes },format: :js
        }.to change(question.answers, :count).by(1)

        new_answer = question.answers.find_by(body: new_body)
        new_answer.files.attach(create_file_blob)
        expect(new_answer).not_to be_nil
        expect(user).to be_author(new_answer)
        expect(new_answer.files.first.filename).to eq("image.jpg")
      end

      it 'redirects to show question which shows the question and its answers' do
        post :create, params: {question_id: question.id, answer: attributes_for(:answer)},format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not change the answer' do
        post :create, params: {question_id: answer.question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect{response}.to_not change(Answer, :count)
      end

      it "render 'questions/show' template" do
        post :create, params: {question_id: answer.question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'GET #show' do

    context 'Authenticated user ' do
      before { login(user) }

      it 'renders show view which represents @answer' do
        get :show, params: { id: answer}
        expect(response).to render_template :show
      end
    end

    context 'Unauthenticated user ' do

      it 'renders show view which represents @answer' do
        get :show, params: { id: answer}
        expect(response).to render_template :show
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer)}

    context 'Unauthenticated user '  do

      it 'do not deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it 'returns a 401 status' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to have_http_status(401)
      end
    end

    context 'Authenticated user is the author.' do
      before { login(answer.user) }

      it 'deletes the answer' do
        question = answer.question
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
        expect(question.answers.find_by(id: answer.id)).to be_nil
      end

      it 'render the Destroy js' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Authenticated user is not the author.' do
      before { login(user) }

      it "tries delete another's answer" do
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #star' do
    let!(:question) {create(:question)}
    let!(:ranked_answer) {create(:answer, ranked: true, question: question)}
    let!(:not_ranked_answer) {create(:answer, question: question)}
    before{ login(question.user)}

    it 'can NOT be an another ranked answer per question.' do
      expect{patch :star, params: {id: not_ranked_answer}, format: :js}.not_to change(question.answers.ranked, :count)
    end

    it 'can be another answer be ranked instead of previous stared' do
      patch :star, params: {id: not_ranked_answer}, format: :js
      ranked_answer.reload
      not_ranked_answer.reload
      expect(not_ranked_answer).to be_ranked
      expect(ranked_answer).not_to be_ranked
    end
  end

  describe 'PATCH #update' do
    let!(:answer) {create(:answer)}

    describe 'Authenticated author ' do
      before { login(answer.user) }

      context 'with invalid attributes ' do
        it('can not changes answer attributes') do
          expect do
            patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: {id: answer, answer: attributes_for(:answer, :invalid)}, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with valid attributes' do
        it('changes answer attributes') do
          patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
          expect(response).to render_template :update
        end
      end
    end

    describe 'Unauthenticated user ' do
      context 'tries update some answer. ' do

        it "Can't update Answer" do
          patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
          answer.reload
          expect(answer.body).not_to eq 'new body'
        end

      end
    end

    describe 'Not an author authenticated user. Только автор может отредактировать свой ответ ' do
      let!(:user) {create(:user)}
      before {login(user)}

      context 'tries edit some answer. ' do
        it "doesn't change Answer attributes" do
          patch :update, params: {id: answer, answer: {body: 'new body'}}, format: :js
          answer.reload
          expect(answer.body).not_to eq 'new body'
        end

      end
    end
  end
end
