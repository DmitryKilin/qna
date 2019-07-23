require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to(:question)}
  it { should belong_to(:user).inverse_of(:answers).required }

  it { should validate_presence_of :body}
  it { should_not allow_value(' ').for(:body)}

  it { should have_db_column(:question_id).of_type(:integer)  }

  it { should have_db_column(:ranked).of_type(:boolean).with_options(default: false) }
end
