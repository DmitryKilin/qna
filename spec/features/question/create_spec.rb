require 'rails_helper'

feature 'Пользователь может создавать вопрос.', %q{
  In order to get an answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
    given(:user) { create(:user, email: 'user@test.com', password: '12345678') }

    scenario 'Authenticated user asks a question' do
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
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'Только аутентифицированный пользователь может создавать вопросы' do
      visit new_question_path

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
end


