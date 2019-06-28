require 'rails_helper'

feature 'Автор может удалить свой вопрос, но не может удалить чужой вопрос' do
  given(:question) {create(:question)}
  given(:not_an_author) {create(:user, email: 'not_an_author@test.com', password: '12345678')}

  scenario ' tries delete his question' do

    sign_in(question.user)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content "Question have been deleted!"
  end

  scenario 'tries delete some others question' do
    sign_in(not_an_author)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content "You can delete yours questions only!"
  end

end