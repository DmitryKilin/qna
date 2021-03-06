require 'rails_helper'

feature 'Автор может удалить свой ответ, но не может удалить чужой ответ.' do
  given(:answer) { create(:answer) }
  given(:not_an_author) { create(:user, email: 'not_an_author@test.com', password: '12345678') }

  context  'Authorised author' do

    scenario  "can see the delete button and delete answer." do
      sign_in(answer.user)
      visit answer_path(answer)

      expect(page).to have_link('Delete')
    end
  end

  context 'Authorised not the author' do
    scenario "can't see the delete button and delete answer." do
      sign_in(not_an_author)

      expect(page).not_to have_link('Delete')
    end
  end

  context 'Unauthorised user' do
    scenario " can't see the delete button and delete answer." do
      visit answer_path(answer)

      expect(page).not_to have_link('Delete')
    end
  end
end