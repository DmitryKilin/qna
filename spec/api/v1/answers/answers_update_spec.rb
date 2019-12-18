require 'rails_helper'

describe 'Answers API #update', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:answer) { create(:answer) }
  let(:api_path) { "/api/v1/answers/#{answer.id}" }
  let(:method) { :patch }


  describe 'POST /api/v1/answers/:id' do
    context 'with valid params ' do
      let(:answer_attributes) { attributes_for(:answer) }
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      let(:valid_params) { { access_token: access_token.token, id: answer.id, answer: answer_attributes } }

      it_behaves_like 'API Authorizable'
      it 'assigns the requested question to @question' do
        do_request(method, api_path, params: valid_params, headers: headers)
        expect(assigns(:answer)).to eq answer
      end
      it 'changes answer attributes' do
        do_request(method, api_path, params: valid_params, headers: headers)
        answer.reload

        expect(answer.body).to eq answer_attributes[:body]
      end
    end
    context 'with invalid attributes' do
      let(:invalid_attributes) { attributes_for(:answer, :invalid) }
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      let(:request_params) { { access_token: access_token.token, id: answer.id, answer: invalid_attributes } }

      it 'does not save the answer' do
        expect { do_request(method, api_path, params: request_params, headers: headers) }.to_not change(Answer, :count)
      end

      it 'returns :unprocessable_entity status' do
        do_request(method, api_path, params: request_params, headers: headers)
        expect(response.status).to eq 422
      end
    end
  end
end
