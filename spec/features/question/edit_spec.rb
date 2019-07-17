require 'rails_helper'

feature 'User can edit his question.' do
  given!(:question) {create(:question)}

  describe 'Authenticated user ' do
    given!(:user) {create(:user)}
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can not see Edit button on the others authorship Question show page.', js: true do
      within '.question' do
        expect(page).not_to have_link('Edit')
      end
    end
  end

  describe 'Authenticated author ' do
    before do
      sign_in(question.user)
      visit question_path(question)
    end

    scenario 'can see Edit button on his Question show page.', js: true do
      within '.question' do
        expect(page).to have_link('Edit')
      end
    end

    scenario 'edit his Question',js: true do
      within '.question' do
        click_on 'Edit'

        fill_in 'Body', with: 'edited question body'
        fill_in 'Title', with: 'edited question title'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question body'
        expect(page).to have_content 'edited question title'
      end
    end

    scenario 'edit his answer with errors', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Body', with: ' '
        expect(page).to have_content question.body
      end
    end

  end

  describe 'Unauthenticated user ' do
    before {visit question_path(question)}

    scenario 'can not see Edit button on the others authorship Question show page.', js: true do
      within '.question' do
        expect(page).not_to have_link('Edit')
      end
    end
  end
end