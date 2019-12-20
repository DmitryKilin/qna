shared_examples_for 'API Attachable' do
  describe 'In case of using resources with attachments ' do
    let(:files) { resource_response['files'] }
    before do
      resource_essence.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
      resource_essence.files.attach(io: File.open("#{Rails.root}/spec/spec_helper.rb"), filename: 'spec_helper.rb')
      do_request(:get, api_path, params: request_params, headers: headers)
    end
    it 'returns files ' do
      expect(files.size).to eq resource_essence.files.count
    end
    it 'returns files urls ' do
      expect(files.first).to eq rails_blob_path(resource_essence.files.first, only_path: true)
    end
  end
end
