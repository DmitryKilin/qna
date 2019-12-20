require 'rails_helper'

describe 'Answers API #delete', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:answer) { create(:answer) }
  let(:api_path) { "/api/v1/answers/#{answer.id}" }
  let(:method) { :delete }

  describe 'DELETE /api/v1/answers/:id' do
    context 'with valid params ' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      let(:valid_params) { { access_token: access_token.token, id: answer.id } }

      it_behaves_like 'API Authorizable'

      it 'deletes the answer ' do
        do_request(method, api_path, params: valid_params, headers: headers)
        expect(Answer.count).to eq 0
      end
    end
  end
end