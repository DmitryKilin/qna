require 'rails_helper'

feature 'User can edit his answer.' do
  given!(:answer) {create(:answer)}

  describe 'Authenticated user' do
    before  do
      sign_in(answer.user)
      visit question_path(answer.question)
    end

    scenario 'edit his answer.', js: true do
      within '.answers' do
        click_on 'Edit'

        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors', js: true do
      within '.answers' do
        click_on 'Edit'

        fill_in 'Body', with: ' '
        click_on 'Save'
      end

      within '.answer-errors' do
        expect(page).to have_content 'error(s) detected:'
      end
    end

    scenario 'can attache a files to his answer'
    scenario 'can delete attached file/files from his answer'
  end

  describe 'Unautheticated user ' do
    before { visit question_path(answer.question) }

    scenario "can't see Edit link" do
      within '.answers' do
        expect(page).not_to have_link('Edit')
      end
    end

  end

  describe 'Not an author ' do
    given! (:user) { create(:user) }
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario "can't see Edit link" do
      within '.answers' do
        expect(page).not_to have_link('Edit')
      end
    end
  end
end