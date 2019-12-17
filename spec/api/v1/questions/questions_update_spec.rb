require 'rails_helper'

describe 'Questions API #update', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let!(:question) { create(:question) }
  let(:api_path) { "/api/v1/questions/#{question.id}" }
  let(:method) { :patch }


  describe 'POST /api/v1/questions' do
    context 'with valid params ' do
      let(:question_attributes) { attributes_for(:question) }
      let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }
      let(:request_params) { { access_token: access_token.token, id: question, question: question_attributes } }

      it_behaves_like 'API Authorizable'
      it 'assigns the requested question to @question' do
        do_request(method, api_path, params: request_params, headers: headers)
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        do_request(method, api_path, params: request_params, headers: headers)
        question.reload

        expect(question.title).to eq question_attributes[:title]
        expect(question.body).to eq question_attributes[:body]
      end
    end
    context 'with invalid attributes' do
      let(:question_attributes) { attributes_for(:question, :invalid) }
      let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }
      let(:request_params) { { access_token: access_token.token, id: question, question: question_attributes } }

      it 'does not save the question' do
        expect { do_request(method, api_path, params: request_params, headers: headers) }.to_not change(Question, :count)
      end

      it 'returns :unprocessable_entity status' do
        do_request(method, api_path, params: request_params, headers: headers)
        expect(response.status).to eq 422
      end
    end
  end
end
