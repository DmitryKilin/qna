require 'rails_helper'

feature 'User can log out' do
  scenario 'Registered user can log out' do
    user = User.create!(email: 'user@test.com', password: '12345678')
    sign_in(user)

    visit questions_path
    click_on 'Log out'

    expect(page).to have_content "Signed out successfully."
   end
end