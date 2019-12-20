require 'rails_helper'

describe 'Questions API #index', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    context 'authorized ' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:resource_response) { json['questions'].first }
      let(:resource_essence) { question }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:request_params) { nil }
      let(:public_fields) { %w[id title body created_at updated_at] }
      before { get api_path, params: request_params, headers: headers }

      it_behaves_like 'API Public fields visible'
      it 'returns list of questions ' do
        expect(json['questions'].size).to eq 2
      end
      it 'contains user object ' do
        expect(resource_response['user']['id']).to eq question.user.id
      end
      it 'contains short title ' do
        expect(resource_response['short_title']).to eq question.title.truncate(7)
      end
      it 'returns list of answers ' do
        expect(resource_response['answers'].size).to eq 3
      end
      describe 'answers ' do
        let(:question_resource) { json['questions'].first }
        let(:resource_response) { question_resource['answers'].first }
        let(:resource_essence) { answers.first }
        let(:public_fields) { %w[id body created_at updated_at] }

        it_behaves_like 'API Public fields visible'
      end
    end
  end
end