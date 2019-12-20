require 'rails_helper'

describe 'Answer API #show', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:resource_response) { json['answer'] }
    let(:resource_essence) { answer }
    let(:public_fields) { %w[id body created_at updated_at] }
    let(:request_params) { { id: answer } }


    it_behaves_like 'API Attachable'
    it_behaves_like 'API Linkable'
    it_behaves_like 'API Commentable'
    it_behaves_like 'API Public fields visible'
  end
end