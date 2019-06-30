require 'rails_helper'

feature 'Пользователь, находясь на странице вопроса, может написать ответ на вопрос', %q{
  I'd like to write an answer for question direct on the question show page.
  The question page should show a question answers also.
} do

  given(:user) {create(:user, email: 'user@test.com', password: '12345678')}
  given(:question) {create(:question)}

  scenario 'An user can create an answer using the question show page' do
    sign_in(question.user)

    visit question_path(question)
    fill_in(:answer_body, with: 'Some new answer')
    click_on 'Answer'
    expect(page).to have_content 'Some new answer'
  end

  scenario 'Только аутентифицированный пользователь может создавать ответы' do
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User tries to give a impermissible answer' do
    sign_in(user)

    visit question_path(question)
    fill_in(:answer_body, with: ' ')

    click_on 'Answer'

    expect(page).to have_content "Unable to save answer"
  end
end