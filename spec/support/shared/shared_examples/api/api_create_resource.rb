shared_examples_for 'API create resource' do
  describe 'In case of creating resources with links ' do
    context 'with valid params ' do

      it_behaves_like 'API Authorizable' do let(:method) { :post } end
      it 'creates a new resource ' do
        expect { do_request(method, api_path, params: valid_params, headers: headers) }.to change(resource, :count).by(1)
      end
      it 'creates answer links' do
        expect { do_request(method, api_path, params: valid_params, headers: headers) }.to change(Link, :count).by(2)
      end
    end
    context 'with invalid params ' do
      it 'does NOT creates invalid resource' do
        expect { do_request(method, api_path, params: invalid_params, headers: headers) }.to_not change(resource, :count)
      end
      it 'returns :unprocessable_entity status' do
        do_request(method, api_path, params: invalid_params, headers: headers)
        expect(response.status).to eq 422
      end
    end
  end
end