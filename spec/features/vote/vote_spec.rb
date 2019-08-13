require 'rails_helper'

feature 'It can to vote. ' do
  given(:some_voter) { create(:user) }
  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }

  scenario 'A user can see poll result. ', js: true do
    visit question_path( question )
    expect( page ).to have_selector( '.poll' )
  end

  describe 'Any authenticated user EXCEPT author' do
    background do
      sign_in(some_voter)
      visit question_path( question )
    end

    scenario 'Can vote up. ' do
      click_on 'Vote UP'

      within '.poll' do
        expect(page).to have_content '1'
      end
    end

    scenario 'Can vote down. ' do
      click_on 'Vote UP'

      within '.poll' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'Can NOT vote up twice. ' do
      click_on 'Vote UP'
      click_on 'Vote UP'

      within '.poll' do
        expect(page).to have_content '1'
      end
    end

    scenario 'Can NOT vote down twice. ' do
      click_on 'Vote DOWN'
      click_on 'Vote DOWN'

      within '.poll' do
        expect(page).to have_content '-1'
      end
    end

    scenario 'Can  change vote. ' do
      click_on 'Vote UP'
      within '.poll' do
        expect(page).to have_content '1'
      end

      click_on 'Vote DOWN'
      within '.poll' do
        expect(page).to have_content '1'
      end

      click_on 'Vote DOWN'
      within '.poll' do
        expect(page).to have_content '0'
      end

      click_on 'Vote DOWN'
      within '.poll' do
        expect(page).to have_content '-1'
      end
    end

  end

end