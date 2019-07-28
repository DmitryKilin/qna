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

    scenario 'can not see Delete file button on the others authorship Question show page.', js: true do
      click_on 'Sign out'
      sign_in(question.user)
      visit question_path(question)
      within '.question' do
        click_on 'Edit'

        fill_in 'Body', with: 'edited question body'
        fill_in 'Title', with: 'edited question title'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'
      end
      click_on 'Sign out'
      sign_in(user)
      visit question_path(question)
      within '.question' do
        expect(page).not_to have_link('Delete file')
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

    scenario 'can edit question with attached files', js: true do
      within '.question' do
        click_on 'Edit'

        fill_in 'Body', with: 'edited question body'
        fill_in 'Title', with: 'edited question title'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited question body'
        expect(page).to have_content 'edited question title'
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end
    scenario 'can delete attached file/files', js: true  do
      within '.question' do
        click_on 'Edit'

        fill_in 'Body', with: 'edited question body'
        fill_in 'Title', with: 'edited question title'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'
        expect(page).to have_link('Delete file')
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