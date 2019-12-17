shared_examples_for 'API Commentable' do
  describe 'In case of using resources with attachments ' do
    let(:comments) { resource_response['comments'] }
    let(:comment_owner) { create(:user) }
    before do
      resource_essence.comments.create!(body: 'Comment1', user: comment_owner)
      resource_essence.comments.create!(body: 'Comment2', user: comment_owner)
    end

    it 'returns comments ' do
      do_request(:get, api_path, params: request_params, headers: headers)
      expect(comments.size).to eq resource_essence.comments.count
    end
    it 'returns proper comments ' do
      do_request(:get, api_path, params: request_params, headers: headers)
      expect(comments.to_json).to eq resource_essence.comments.to_json
    end
  end
end
