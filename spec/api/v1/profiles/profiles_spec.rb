require 'rails_helper'

describe 'Profiles API ', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:public_fields) { %w[id email admin created_at updated_at] }
  let(:private_fields) { %w[password encrypted_password] }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable'

    context 'authorized ' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:me_response) { json['user'] }
      let(:resource_response) { me_response }
      let(:resource_essence) { me }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Public fields visible'
      it_behaves_like 'API Private fields not visible'
    end
  end
  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API Authorizable'

    context 'authorized ' do
      let!(:users) { create_list(:user, 2) }

      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:api_response) { json['users'] }
      let(:user_in_response) { api_response.first }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      context 'not me authorized ' do
        let(:access_token) { create(:access_token) }
        let(:resource_response) { user_in_response }
        let(:resource_essence) { users.first }

        before { get api_path, params: { access_token: access_token.token }, headers: headers }

        it_behaves_like 'API Public fields visible'
        it_behaves_like 'API Private fields not visible'

        it 'returns list of users ' do
          expect(api_response.size).to eq 2
        end
      end
      context 'me authorized ' do
        let(:me) { users.first }
        before { get api_path, params: { access_token: access_token.token }, headers: headers }

        it 'does NOT return authenticated user' do
          expect(api_response).to_not be_include(me)
        end
      end
    end
  end
end
