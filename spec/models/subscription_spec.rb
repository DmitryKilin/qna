require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:question_id).of_type(:integer) }
  it { should validate_presence_of :user }
  it { should validate_presence_of :question }
  it { should belong_to(:user).inverse_of(:subscriptions) }
  it { should belong_to(:question).inverse_of(:subscriptions) }
end