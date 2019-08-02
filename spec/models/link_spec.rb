require 'rails_helper'

RSpec.describe Link, type: :model do
  it {should belong_to :linkable}

  it { should validate_presence_of :name}
  it { should validate_presence_of :url}

  describe  '#gist?' do
    let(:question) {create(:question)}

    it 'true if url link to a gist' do
      question.links.create(name: "Gist", url: "https://gist.github.com/DmitryKilin/0f6260bee40dac34d43ecc48caa06913")
      expect(question.links.first).to be_gist
    end

    it 'false if url does NOT link to a gist' do
      question.links.create(name: "Google", url: "https://google.ru")
      expect(question.links.first).not_to be_gist
    end
  end
end

