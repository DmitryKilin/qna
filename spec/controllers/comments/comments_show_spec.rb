require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'GET #show' do
    let(:comment) { create(:comment, :comment_question)}

    it 'renders show view which represents @comment' do
      get :show, params: { id: comment }
     expect(response).to render_template :show
    end
end

end