require 'rails_helper'

describe 'Question API #show', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question, :with_comments, :with_links, :with_attachments, :with_answers) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }
    let(:method) { :get }
    let(:question_response) { json['question'] }

    it_behaves_like 'API Authorizable'

    it 'returns files ' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(question_response['files'].size).to eq 2
    end

    it 'returns files urls ' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(question_response['files'].first).to eq rails_blob_path(question.files.first, only_path: true)
    end

    it 'returns comments ' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(question_response['files'].size).to eq 2
    end

    it 'returns links ' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(question_response['links'].size).to eq 2
    end

    it 'returns all public fields ' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      %w[id title body created_at updated_at].each do |attr|
        expect(question_response[attr]).to eq question.send(attr).as_json
      end
    end
  end
end