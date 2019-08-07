require 'rails_helper'

RSpec.describe Link, type: :model do
  it {should belong_to :linkable}

  it { should validate_presence_of :name}
  it { should validate_presence_of :url}

  describe  '#gist?' do
    let!(:question) {create(:question)}

    describe ' link is the gist' do
      let!(:link) {create(:link, :gist, linkable: question)}

      it 'true if url link to a gist' do
        expect(question.links.first).to be_gist
    end

    end
    describe ' link is NOT the gist' do
      let!(:link) {create(:link, linkable: question)}

      it 'false if url does NOT link to a gist' do
        expect(question.links.first).not_to be_gist
      end
    end
  end

  describe '#gist_id' do
    let!(:question) {create(:question)}
    let!(:link) {create(:link, :gist, linkable: question)}
    it 'returns the gist_id from the gist URL' do
      # question.links.create(attributes_for(:link, :gist))
      expect(question.links.first.gist_id).to eq '0f6260bee40dac34d43ecc48caa06913'
    end
  end
end

