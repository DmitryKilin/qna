require 'rails_helper'

feature 'A user can see the search page' do

  scenario 'A quest can see a search page' do
    visit search_get_search_path

    within('form#search') do
      expect(page).to have_field 'Search'
      expect(page).to have_field 'Search:'
    end

    expect(page).to have_field 'question_flag'
    expect(page).to have_field 'answer_flag'
    expect(page).to have_field 'comment_flag'
    expect(page).to have_field 'user_flag'
  end
end