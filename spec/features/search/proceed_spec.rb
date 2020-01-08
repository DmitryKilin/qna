require 'rails_helper'

feature 'Пользователь может искать вопрос по строке символов. ' do
  given!(:question1) { create(:question, title: "The slings and arrows of outrageous fortune")}
  given!(:question2) { create(:question, title: 'Or to take arms against a sea of troubles')}
  scenario 'A quest can find a question keeping a string in a questions title or a body. ', js: true do
    visit search_get_search_path

    within 'form' do
      fill_in 'Search:', with: 'to take arms'
      click_on 'Search'
    end

    expect(current_path).to eq search_get_search_path
    within '#question_entries' do
      expect(page).to have_content 'to take arms'
    end
  end
end