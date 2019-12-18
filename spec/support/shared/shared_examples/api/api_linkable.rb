shared_examples_for 'API Linkable' do
  describe 'In case of using resources with attachments ' do
    let(:links) { resource_response['links'] }
    before do
      resource_essence.links.create!(name: 'link1', url: 'https://www.link1.com')
      resource_essence.links.create!(name: 'link2', url: 'https://www.link2.com')
      do_request(:get, api_path, params: request_params, headers: headers)
    end

    it 'returns links ' do
      expect(links.size).to eq resource_essence.links.count
    end
    it 'returns proper links ' do
      expect(links.to_json).to eq resource_essence.links.to_json
    end
  end
end
