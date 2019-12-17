require 'rails_helper'

describe 'Question API #create', type: :request do
  let!(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:request_params) { { access_token: access_token.token, question: question_params } }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:api_path) { '/api/v1/questions' }
  let(:method) { :post }


  describe 'POST /api/v1/questions' do
    context 'with valid params ' do
      let(:request_params) { { access_token: access_token.token, question: question_params } }

      it_behaves_like 'API Authorizable' do let(:method) { :post } end
      it 'creates a new question ' do
        expect { do_request(method, api_path, params: request_params, headers: headers) }.to change(Question, :count).by(1)
      end
      it 'creates question links' do
        expect { do_request(method, api_path, params: request_params, headers: headers) }.to change(Link, :count).by(2)
      end
    end
    context 'with invalid params ' do
      let(:question_params) { attributes_for(:question, :invalid) }

      it 'does NOT creates invalid question' do
        expect { do_request(method, api_path, params: request_params, headers: headers) }.to_not change(Question, :count)
      end
      it 'returns :unprocessable_entity status' do
        do_request(method, api_path, params: request_params, headers: headers)
        expect(response.status).to eq 422
      end
    end
  end
end
