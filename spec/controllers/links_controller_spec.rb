require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let!(:question) {create(:question)}
  let!(:link) {create(:link, :gist, linkable: question)}

  describe "DELETE #destroy" do
    context 'Authenticated author ' do
      before {login(question.user)}

      it 'deletes link' do
        expect{delete :destroy, params: {id: question.links.first}, format: :js}.to change(question.links, :count).by(-1)
      end
    end

    context 'Unauthenticated user' do
      it 'can NOT deletes links' do
        expect{delete :destroy, params: {id: question.links.first}, format: :js}.not_to change(question.links, :count)
      end
    end

    context 'Authenticated NOT the author' do
      let!(:user){create(:user)}
      before {login(user)}

      it 'can NOT deletes links' do
        expect{delete :destroy, params: {id: question.links.first}, format: :js}.not_to change(question.links, :count)
      end
    end
  end
end
