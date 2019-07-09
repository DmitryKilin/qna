require 'rails_helper'

feature 'User can edit his answer.' do
  given!(:answer) {create(:answer)}

  scenario 'Unauthenticated user can not edit answer' do

  end

  describe 'Authenticated user' do
    scenario 'edit his answer.', js: true do
      visit question_path(answer.question)

      expect(page).not_to have_link('Edit')
    end

    scenario 'edit his answer with errors', js: true do
      sign_in(answer.user)
      visit question_path(answer.question)
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit other user answer'
  end
end