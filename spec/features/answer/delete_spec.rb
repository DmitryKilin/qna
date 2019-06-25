require 'rails_helper'

feature 'Автор может удалить свой ответ, но не может удалить чужой ответ' do
  given(:answer) {create(:answer, :with_authorship)}
  #
  # scenario 'Author tries delete his answer' do
  #   user = create(:user, email: 'user@test.com', password: '12345678')
  #
  #   sign_in(user)
  #   visit question_path(answer)
  #   click_on 'Delete'
  #
  #   expect(page).to have_content "Answer have been deleted!"
  # end

end