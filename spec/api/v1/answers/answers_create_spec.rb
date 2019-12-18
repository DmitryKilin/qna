require 'rails_helper'

describe 'Answer API #create', type: :request do
  let!(:me) { create(:user) }
  let!(:question) { create(:question) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
  let(:method) { :post }


  describe 'POST /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API create resource' do
      let(:resource) { Answer }
      let(:valid_params) { { access_token: access_token.token, question_id: question, answer: answer_params } }
      let(:invalid_params) { { access_token: access_token.token, question_id: question, answer: attributes_for(:answer, :invalid) } }
    end
  end
end