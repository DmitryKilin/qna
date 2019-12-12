require 'rails_helper'

describe 'Question API #show_answers', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:id/show_answers' do
    let!(:question) { create(:question, :with_answers) }
    let(:api_path) { "/api/v1/questions/#{question.id}/show_answers" }
    let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    it 'returns answers ' do
      do_request(method, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(json['answers'].size).to eq 2
    end
  end
end