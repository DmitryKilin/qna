require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to(:question)}
  it { should belong_to(:user).inverse_of(:answers).required }
  it { should have_many(:links).dependent(:destroy) }


  it { should validate_presence_of :body}
  it { should_not allow_value(' ').for(:body)}

  it { should accept_nested_attributes_for :links }


  it { should have_db_column(:question_id).of_type(:integer)  }
  it { should have_db_column(:ranked).of_type(:boolean).with_options(default: false) }

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe  '#rank'do
    let!(:question) {create(:question_with_answers, first_ranked: true)}
    let!(:user) {question.user}
    let!(:prize){create(:prize, question: question)}
    let!(:answer_first) {question.answers.first}
    let!(:answer_second) {question.answers.second}


    it { is_expected.to respond_to(:rank) }

    it 'It flags the ranked attribute' do
      expect(answer_first).to be_ranked
      expect(answer_second).not_to be_ranked

      answer_second.rank

      answer_first.reload
      answer_second.reload

      expect(answer_first).not_to be_ranked
      expect(answer_second).to be_ranked
    end

    it 'Assignes the Prize User attribute' do
      expect(prize.user).to be_nil
      answer_second.rank
      prize.reload
      expect(prize.user).to eq(answer_second.user)
    end
  end

  describe  '#unrank'do
    let!(:question) {create(:question_with_answers, first_ranked: true)}
    let!(:user) {question.user}
    let!(:answer_first) {question.answers.first}
    let!(:answer_second) {question.answers.second}
    let!(:prize){create(:prize, question: question, user: answer_first.user)}


    it { is_expected.to respond_to(:unrank) }

    it 'It unflags the ranked attribute' do
      answer_first.unrank

      answer_first.reload
      answer_second.reload

      expect(answer_first).not_to be_ranked
      expect(answer_second).not_to be_ranked
    end

    it 'Assignes nil to the Prize User attribute' do
      expect(prize.user).to eq(answer_first.user)
      answer_first.unrank
      prize.reload
      expect(prize.user).to be_nil
    end
  end

  it_behaves_like 'votable'

end
