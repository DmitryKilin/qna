require 'rails_helper'

feature 'Пользователь, находясь на странице вопроса, может написать ответ на вопрос', %q{
  I'd like to write an answer for question direct on the question show page.
  The question page should show a question answers also.
} do

  given(:user) {create(:user, email: 'user@test.com', password: '12345678')}
  given(:question) {create(:question)}
  given(:search_engine_url1) {'https://yandex.ru'}
  given(:search_engine_url2) {'https://google.ru'}

  describe 'Authenticated user ' do
    scenario 'create an answer and it appears on all opened subscribers question show pages', js: true do
      Capybara.using_session('user') do
        sign_in(question.user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in(:answer_body, with: 'Some new answer')

        within '#links' do
          fill_in 'Link name', with: 'Favorite searching1'
          fill_in 'Url', with: search_engine_url1
        end

        click_on 'Answer'

        expect(current_path).to eq question_path(question)

        within '.answers' do
          expect(page).to have_content 'Some new answer'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Some new answer'
        end
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

    scenario 'creates an answer with attached files', js: true do
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