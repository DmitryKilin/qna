require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }
  it { should validate_presence_of :definition }
  it { should validate_inclusion_of( :definition ).in_array([1,-1]) }
  it { should have_db_index([:votable_type, :votable_id, :user_id]).unique(true)}
end