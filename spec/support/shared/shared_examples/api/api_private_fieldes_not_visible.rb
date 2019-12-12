shared_examples_for 'API Private fields not visible' do
  it 'does NOT returns private_fields fields ' do
    do_request(:get, api_path, params: { access_token: access_token.token }, headers: headers)
    private_fields.each do |attr|
      expect(resource_response[attr]).not_to eq resource_essence.send(attr).as_json
    end
  end
end
