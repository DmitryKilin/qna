require 'rails_helper'

describe 'Answers API #index', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 3, question: question) }
    let(:answer) { answers.first }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    context 'authorized ' do
      let(:answers_response) { json['answers'] }
      let(:resource_response) { answers_response.first }
      let(:resource_essence) { answer }
      let(:public_fields) { %w[id body created_at updated_at] }
      let(:request_params) { nil }
      before { get api_path, params: request_params, headers: headers }

      it 'returns list of answers ' do
        expect(answers_response.size).to eq 3
      end
      it 'contains user object ' do
        expect(resource_response['user']['id']).to eq resource_essence.user.id
      end
      it_behaves_like 'API Public fields visible'

    end
  end
end