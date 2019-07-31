require 'rails_helper.rb'

feature 'User can add links to a question. ', %q{
  In order to provide additional info to a question
  as an author I'd like to add a links
} do
  given(:user) { create(:user) }
  given(:search_engine_url) {'https://yandex.ru'}

  scenario 'User adds link when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    fill_in 'Link name', with: 'Favorite searching'
    fill_in 'Url', with: search_engine_url

    click_on 'Ask'

    expect(page).to have_link 'Favorite searching', href: search_engine_url
  end
end
