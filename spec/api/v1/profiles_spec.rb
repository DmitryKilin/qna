require 'rails_helper'

describe 'Profiles API ', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized ' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:me_response) { json['user'] }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields ' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(me_response[attr]).to eq me.send(attr).as_json
        end
      end
      it 'does NOT returns private fields ' do
        %w[password encrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized ' do
      let!(:users) { create_list(:user, 2) }

      let(:some_user) { users.first }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:api_response) { json['users'] }
      let(:user_in_response) { api_response.first }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      context 'not me authorized ' do
        let(:access_token) { create(:access_token) }
        before { get api_path, params: { access_token: access_token.token }, headers: headers }

        it 'returns list of users ' do
          expect(api_response.size).to eq 2
        end
        it 'returns all public fields ' do
          %w[id email admin created_at updated_at].each do |attr|
            expect(user_in_response[attr]).to eq some_user.send(attr).as_json
          end
        end
        it 'does NOT returns private fields ' do
          %w[password encrypted_password].each do |attr|
            expect(user_in_response[attr]).not_to eq some_user.send(attr).as_json
          end
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
