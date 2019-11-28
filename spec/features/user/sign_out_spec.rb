require 'rails_helper'

feature 'Пользователь может выйти из системы' do

  scenario 'Registered user can log out' do
    user = create(:user, email: 'user@test.com', password: '12345678')
    sign_in(user)

    visit root_path
    click_on 'Sign out'

    expect(page).to have_content "Signed out successfully."
   end
end