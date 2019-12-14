require 'rails_helper'

describe 'Question API #create', type: :request do
  let!(:me) { create(:user, admin: true) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token, question: attributes_for(:question) } }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:api_path) { "/api/v1/questions" }

  it_behaves_like 'API Authorizable'

  describe 'POST /api/v1/questions' do
    it 'creates a new question ' do
      expect { post api_path, params: request_params, headers: headers }.to change(Question, :count).by(1)
    end
  end
end