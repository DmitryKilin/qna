require 'rails_helper.rb'

feature 'User can add links to a answer. ', %q{
  In order to provide additional info to a answer
  as an author I'd like to add a links
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:search_engine_url) {'https://yandex.ru'}

  scenario 'User adds link give an answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in(:answer_body, with: 'Some new answer')

    fill_in 'Link name', with: 'Favorite searching'
    fill_in 'Url', with: search_engine_url
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'Favorite searching', href: search_engine_url
    end
  end
end