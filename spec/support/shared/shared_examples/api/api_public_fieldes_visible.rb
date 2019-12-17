shared_examples_for 'API Public fields visible' do
  it 'returns public fields ' do
    do_request(:get, api_path, params: request_params, headers: headers)
    public_fields.each do |attr|
      expect(resource_response[attr]).to eq resource_essence.send(attr).as_json
    end
  end
end
