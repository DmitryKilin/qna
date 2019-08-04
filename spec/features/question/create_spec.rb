require 'rails_helper'

feature 'Пользователь может создавать вопрос.', %q{
  In order to get an answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
    given(:user) { create(:user, email: 'user@test.com', password: '12345678') }
    given(:search_engine_url1) {'https://yandex.ru'}
    given(:my_gist) {"https://gist.github.com/DmitryKilin/0f6260bee40dac34d43ecc48caa06913"}

    scenario 'Authenticated user asks a question with links', js: true do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'

      click_link 'Add Link'

      page.all('input.form-control',{id: %r{question_links_attributes_.}})[0].set('Favorite searching1')
      page.all('input.form-control',{id: %r{question_links_attributes_.}})[1].set(search_engine_url1)

      page.all('input.form-control',{id: %r{question_links_attributes_.}})[2].set('My Gist')
      page.all('input.form-control',{id: %r{question_links_attributes_.}})[3].set(my_gist)

      click_on 'Ask'

      expect(page).to have_content "Your question successfully created"
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'some text'
      expect(page).to have_link 'Favorite searching1', href: search_engine_url1
      expect(page).to have_link 'My Gist', href: my_gist
    end

    scenario 'Authenticated user asks a question with error', js: true do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'Authenticated user asks a question using invalid url in the Link field', js: true do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'

      fill_in 'Link name', with: 'Invalid URL'
      fill_in 'Url', with:'http://Invalid'

      click_on 'Ask'

      expect(page).to have_content('Links url is an invalid URL')
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

    scenario 'Authenticated user asks the question with Reward ' do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'some text'
      fill_in 'Praise', with: 'You are the Star!'

      attach_file 'Reward', "#{Rails.root}/spec/fixtures/files/star.png"

      click_on 'Ask'

      expect(page).to have_selector('img#img-star')
      expect(page).to have_text('You are the Star!')
    end
  end


