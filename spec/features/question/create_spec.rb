require 'rails_helper'

feature 'Пользователь может создавать вопрос.', %q{
  In order to get an answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
    given(:user) { create(:user, email: 'user@test.com', password: '12345678') }
    given(:search_engine_url1) {'https://yandex.ru'}
    given(:search_engine_url2) {'https://google.ru'}

    scenario 'Authenticated user asks a question with links', js: true do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'

      click_link 'Add Link'

      page.all('input.form-control',{id: %r{question_links_attributes_.}})[0].set('Favorite searching1')
      page.all('input.form-control',{id: %r{question_links_attributes_.}})[1].set(search_engine_url1)

      page.all('input.form-control',{id: %r{question_links_attributes_.}})[2].set('Favorite searching2')
      page.all('input.form-control',{id: %r{question_links_attributes_.}})[3].set(search_engine_url2)

      click_on 'Ask'

      expect(page).to have_content "Your question successfully created"
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'some text'
      expect(page).to have_link 'Favorite searching1', href: search_engine_url1
      expect(page).to have_link 'Favorite searching2', href: search_engine_url2
    end

    scenario 'Authenticated user asks a question with error', js: true do
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

    scenario 'Authenticated user asks the question with attached file ' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link('rails_helper.rb')
      expect(page).to have_link('spec_helper.rb')
    end
end


