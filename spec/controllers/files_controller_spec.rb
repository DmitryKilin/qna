require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:attachment) {fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb')}
  let!(:question) {create(:question)}
  before{question.files.attach(attachment)}

  describe "DELETE #destroy" do
    context 'Authenticated author ' do
      before {login(question.user)}

      it 'deletes attachment' do
        expect{delete :destroy, params: {id: question.files.first}, format: :js}.to change(question.files, :count).by(-1)
      end
    end

    context 'Unauthenticated user' do
      it 'can NOT deletes attachment' do
        expect{delete :destroy, params: {id: question.files.first}, format: :js}.not_to change(question.files, :count)
      end
    end

    context 'Authenticated NOT the author' do
      let!(:user){create(:user)}
      before {login(user)}

      it 'can NOT deletes attachment' do
        expect{delete :destroy, params: {id: question.files.first}, format: :js}.not_to change(question.files, :count)
      end
    end
  end
end
