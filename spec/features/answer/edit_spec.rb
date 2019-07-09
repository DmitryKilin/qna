require 'rails_helper'

feature 'User can edit his answer.' do
  given!(:answer) {create(:answer)}

  describe 'Authenticated user' do
    before  do
      sign_in(answer.user)
      visit question_path(answer.question)
    end
    scenario 'edit his answer.', js: true do
      expect(page).to have_link('Edit')
    end

    scenario 'edit his answer with errors', js: true do

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end
  describe 'Unautheticated user ' do
    before { visit question_path(answer.question) }

    scenario "can't see Edit link" do
      expect(page).not_to have_link('Edit')
    end
  end

  describe 'Not an author ' do
    given! (:user) { create(:user) }
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario "can't see Edit link" do
      expect(page).not_to have_link('Edit')
    end
  end
end