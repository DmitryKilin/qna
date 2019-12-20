require 'rails_helper'

describe 'Questions API #delete', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:question) { create(:question) }
  let(:api_path) { "/api/v1/questions/#{question.id}" }
  let(:method) { :delete }

  describe 'DELETE /api/v1/questions' do
    context 'with valid params ' do
      let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }
      let(:valid_params) { { access_token: access_token.token, id: question } }

      it_behaves_like 'API Authorizable'

      it 'deletes the question ' do
        do_request(method, api_path, params: valid_params, headers: headers)
        expect(Question.count).to eq 0
      end
    end
  end
end
