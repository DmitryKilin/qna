require 'rails_helper'

feature 'Автор может удалить свой комментарий, но не может удалить чужой комментарий.' do
  given(:comment) { create(:comment, :comment_question) }
  given(:not_an_author) { create(:user, email: 'not_an_author@test.com', password: '12345678') }

  context  'Authorised author' do

    scenario  "can see the delete button and delete answer." do
      sign_in(comment.user)
      visit comment_path(comment)

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