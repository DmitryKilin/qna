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
end
