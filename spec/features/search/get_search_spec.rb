require 'rails_helper'

feature 'Пользователь может просматривать страницу поиска' do

  scenario 'A quest can see a search page' do
    visit search_get_search_path

    expect(page).to have_link 'Search'
    expect(page).to have_field 'Search:'

    expect(page).to have_field 'Question'
    expect(page).to have_field 'Answer'
    expect(page).to have_field 'Comment'
    expect(page).to have_field 'User'
  end
end