require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user}
  it { should validate_presence_of :provider}
  it { should validate_presence_of :uid}
  it { should have_db_column( :confirmation_code).with_options(default: nil) }

  describe '#email_confirmed?' do
    it 'TRUE if confirmation_code IS nil' do
      authorization = create(:authorization)
      expect(authorization).to be_email_confirmed
    end
    it 'FALSE if confirmation_code is NOT nil' do
      authorization = create(:authorization, :have_to_confirm)
      expect(authorization).not_to be_email_confirmed
    end
  end
end
