require 'rails_helper'

feature 'Пользователь, находясь на странице вопроса, может написать ответ на вопрос', %q{
  I'd like to write an answer for question direct on the question show page.
  The question page should show a question answers also.
} do

  given(:user) {create(:user, email: 'user@test.com', password: '12345678')}
  given(:question) {create(:question)}

  describe 'Authenticated user ' do
    scenario 'create an answer using the question show page', js: true do
      sign_in(question.user)

      visit question_path(question)
      fill_in(:answer_body, with: 'Some new answer')
      click_on 'Answer'
      expect(current_path).to eq question_path(question)

      within '.answers' do
        expect(page).to have_content 'Some new answer'
      end
    end

    scenario 'creates answer with blank fields', js: true do
      sign_in(user)

      visit question_path(question)
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'tries to give a impermissible answer', js: true do
      sign_in(user)

      visit question_path(question)
      fill_in(:answer_body, with: ' ')

      click_on 'Answer'

      expect(page).to have_content "Body is invalid"
    end

    scenario 'creates an answer with attached files' do
      sign_in(question.user)

      visit question_path(question)
      fill_in(:answer_body, with: 'Some new answer')

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer'
      expect(page).to have_link('rails_helper.rb')
      expect(page).to have_link('spec_helper.rb')
    end

  end

  describe  'Unauthenticated user ' do
    scenario "can't see the new Answer button.", js: true do
      visit question_path(question)

      expect(page).not_to have_button 'Answer'
      end
  end

end