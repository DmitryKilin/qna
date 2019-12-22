require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user, admin: true) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view which represents @question' do
      expect(response).to render_template :show
    end

    it 'assigns the new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns the new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    context 'Authorised user ' do
      before { login(user) }
      before { get :new }

      it 'assigns a new Question into @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assigns a new Link into Question' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'assigns a new Prize into Question' do
        expect(assigns(:question).prize).to be_a_new(Prize)
      end

      it 'renders new view which represents @question' do
        expect(response).to render_template :new
      end
    end

    context  'Unauthenticated user ' do
      before { get :new }

      it 'redirects to authenticate.' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    context 'Authenticated user ' do
      before { login(user) }
      before { get :edit, params: { id: question} }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view which represents @question' do
        expect(response).to render_template :edit
      end
    end

    context  'Unauthenticated user ' do
      before { get :edit, params: { id: question} }

      it 'redirects to authenticate.' do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do

      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
      it 'redirectes to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let!(:question_attributes) {attributes_for(:question, :invalid)}
      before { patch :update, params: { id: question, question: question_attributes }, format: :js
      }
      it 'does not change the question' do
        old_question = question.dup
        question.reload

        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end

      it 're-renders edit view' do
        expect(response).to render_template :update
      end
    end

    context "Unauthenticated user" do
      before {sign_out(user)}

      it "can't update the question." do
        old_question = question.dup

        question.reload

        expect(question.title).to eq old_question.title
        expect(question.body).to eq old_question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question)}

    context 'Authenticated user is the author ' do
      before { login(question.user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to redirect_to questions_path
      end

      it 'deletes a proper question.' do
        delete :destroy, params: { id: question }, format: :js
        expect(Question.exists?(question.id)).to be_falsey
      end
    end

    context 'Authenticated user is not the author ' do
      before { login(user) }

      it "tries delete another's question." do
        expect { delete :destroy, params: { id: question }, format: :js }.not_to change(Question, :count)
      end
    end

    context 'Unauthenticated user ' do
      it 'can not delete the question.' do
        expect { delete :destroy, params: { id: question }, format: :js }.not_to change(Question, :count)
      end
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    context 'Unauthenticated user ' do

      it 'sugested to authenticate.' do
        new_question_attributes = attributes_for(:question)
        post :create, params: {question: new_question_attributes }
        expect(response).to redirect_to new_user_session_path
        expect(Question.exists?(new_question_attributes)).to be_falsey
      end
    end

    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: {question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end

      it 'created question attributes with attachment are equal the input' do
        new_question_attributes = attributes_for(:question, :with_attachments)
        new_title = new_question_attributes[:title]
        new_body = new_question_attributes[:body]

        expect {
          post :create, params: { question: new_question_attributes }
        }.to change(Question, :count).by(1)

        new_question = Question.find_by(title: new_title, body: new_body)

        expect(new_question).not_to be_nil
        expect(user).to be_author(new_question)
        expect(new_question.files.first.filename).to eq("rails_helper.rb")
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save the question' do
        expect { post :create, params: {question: attributes_for(:question, :invalid), format: :js } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: {question: attributes_for(:question, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  it_behaves_like 'voted'

end
