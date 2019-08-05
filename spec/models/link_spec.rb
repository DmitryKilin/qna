require 'rails_helper'

RSpec.describe Link, type: :model do
  it {should belong_to :linkable}

  it { should validate_presence_of :name}
  it { should validate_presence_of :url}

  describe  '#gist?' do
    let(:question) {create(:question)}

    it 'true if url link to a gist' do
      question.links.create(attributes_for(:link, :gist))
      expect(question.links.first).to be_gist
    end

    it 'false if url does NOT link to a gist' do
      question.links.create(attributes_for(:link))
      expect(question.links.first).not_to be_gist
    end
  end

  describe '#gist_id' do
    let(:question) {create(:question)}

    it 'returns the gist_id from the gist URL' do
      question.links.create(attributes_for(:link, :gist))
      expect(question.links.first.gist_id).to eq '0f6260bee40dac34d43ecc48caa06913'
    end
  end
end

