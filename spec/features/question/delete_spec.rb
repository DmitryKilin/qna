require 'rails_helper'

feature 'Автор может удалить свой вопрос, но не может удалить чужой вопрос' do
  given(:question) {create(:question)}
  given(:not_an_author) {create(:user, email: 'not_an_author@test.com', password: '12345678')}

  context  'Authorised not the author' do
    scenario "can't see the delete button." do
      sign_in(not_an_author)

      visit question_path(question)
      expect(page).not_to have_link('Delete')
    end
  end

  context 'Authorised author' do
    background do
      sign_in(question.user)
      visit question_path(question)
    end
    scenario "can see the delete button." do
      expect(page).to have_link('Delete')
    end

    scenario ' tries delete his question' do
      click_on 'Delete'
      expect(page).to have_content "Question have been deleted!"
    end
  end

  context 'Unauthorised user' do
    scenario " can't see the delete button and delete question." do
      visit question_path(question)
      expect(page).not_to have_link('Delete')
    end
  end

end