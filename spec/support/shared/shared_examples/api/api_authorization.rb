shared_examples_for 'API Authorizable' do
  context 'unauthorized ' do
    it 'returns 401 status if access_token is missed ' do
      do_request(:get, api_path, headers: headers)
      expect(response.status).to eq 401
    end
    it 'returns 401 status if access_token is invalid ' do
      do_request(:get, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
  context 'authorized' do
    let(:access_token) { create(:access_token) }

    it 'returns 200 status' do
      do_request(:get, api_path, params: { access_token: access_token.token }, headers: headers)
      expect(response).to be_successful
    end
  end
end