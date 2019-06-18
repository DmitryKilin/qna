require 'rails_helper'

feature 'User can create a question', %q{
  In order to get an answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
    # given(:user) { User.create!(email: 'user@test.com', password: '12345678') }


    scenario 'Authenticated user asks a question' do
      user = User.create!(email: 'user@test.com', password: '12345678')

      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'
      click_on 'Ask'

      expect(page).to have_content "Your question successfully created"
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'some text'
    end

    scenario 'Authenticated user asks a question with error' do
      user = User.create!(email: 'user@test.com', password: '12345678')
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
    scenario 'Unauthenticated user tries to asks a question' do
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
end

