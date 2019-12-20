require 'rails_helper'

describe 'Question API #show', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:resource_response) { json['question'] }
    let(:resource_essence) { question }
    let(:public_fields) { %w[id title body created_at updated_at] }
    let(:request_params) { { id: question } }

    it_behaves_like 'API Attachable'
    it_behaves_like 'API Linkable'
    it_behaves_like 'API Commentable'
    it_behaves_like 'API Public fields visible'
  end
end