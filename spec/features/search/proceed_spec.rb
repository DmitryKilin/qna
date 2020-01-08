require 'sphinx_helper'

feature 'Guests and users can search a phrase in Questions, Answers, Users and Comments  ' do
  given!(:question1) { create(:question, title: "The slings and arrows of outrageous fortune")}
  given!(:question2) { create(:question, title: 'Or to take arms against a sea of troubles')}
  before { visit search_get_search_path }

  describe 'Searching in ', js: true, sphinx: true do
    scenario 'a questions' do
      ThinkingSphinx::Test.run do
        within 'form' do
          fill_in 'Search:', with: 'to take arms'
          click_on 'Search'
        end
        expect(current_path).to eq search_get_search_path
        within '#question' do
          expect(page).to have_content question2.id
        end
      end
    end
  end
end