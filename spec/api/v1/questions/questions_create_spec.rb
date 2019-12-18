require 'rails_helper'

describe 'Question API #create', type: :request do
  let!(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:api_path) { '/api/v1/questions' }
  let(:method) { :post }


  describe 'POST /api/v1/questions' do
    it_behaves_like 'API create resource' do
      let(:resource) { Question }
      let(:valid_params) { { access_token: access_token.token, question: question_params } }
      let(:invalid_params) { { access_token: access_token.token, question: attributes_for(:question, :invalid) } }
    end
  end
end
