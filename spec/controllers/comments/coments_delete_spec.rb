require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:comment) { create(:comment, :comment_question)}

  describe 'GET #destroy' do
    let(:user) { create(:user) }

    context 'Unauthenticated user '  do
      it 'do not deletes the comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.not_to change(Answer, :count)
      end

      it 'returns a Forbidden status' do
        delete :destroy, params: { id: comment }, format: :js
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'Authenticated user is the author.' do
      before { login(comment.user) }

      it 'deletes the comment' do
        expect { delete :destroy, params: { id: comment }, format: :js }.to change(Comment, :count).by(-1)
        expect(Comment.find_by(id: comment.id)).to be_nil
      end

      it 'rendirects to the root path' do
        delete :destroy, params: { id: comment }, format: :js
        expect(response).to redirect_to root_path
      end
    end

  end
end