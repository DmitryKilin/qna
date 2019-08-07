require 'rails_helper'

RSpec.describe Prize, type: :model do
  it { should belong_to(:question).inverse_of(:prize) }
  it { should belong_to(:user).inverse_of(:prizes).optional}

  it 'have Reward attached file' do
    expect(Prize.new.reward).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end