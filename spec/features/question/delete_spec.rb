require 'rails_helper'

feature 'Автор может удалить свой вопрос, но не может удалить чужой вопрос' do
  given(:question) {create(:question, :with_authorship)}
  # given(:user) { create(:user, email: 'user@test.com', password: '12345678') }

  scenario 'Author tries delete his question' do

    sign_in(question.user)

    visit question_path(question)
    click_on 'Delete'

    expect(page).to have_content "Question have been deleted!"
  end

end