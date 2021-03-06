require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:comment) { create :comment }
  let(:question) { create :question }

  describe 'POST #create' do
    before { login(question.user) }

    context 'with valid attributes' do
      it 'saved a new comment in the db' do
        expect do
          post :create, params: { comment: attributes_for(:comment),
                                  question_id: question.id }, format: :json
        end .to change(Comment, :count).by(1)
      end

      it 'generate a proper response' do
        post :create, params: { comment: attributes_for(:comment),
                                question_id: question.id }, format: :json

        c = assigns(:comment)
        my_hash = { id: c.id, body: c.body, user_email: question.user.email, commented_resource: 'question', commented_resource_id: c.commentable_id }
        response_page = JSON.generate(my_hash)

        expect(response.content_type).to eq('application/json')
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(response_page)
      end
    end

    context 'with invalid attributes' do
      it 'do NOT saves a new comment in the db' do
        expect do
          post :create, params: { comment: attributes_for(:comment, :invalid),
                                  question_id: question.id }, format: :json
        end .to_not change(Comment, :count)
      end
    end
  end
end
