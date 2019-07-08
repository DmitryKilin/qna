require 'rails_helper'

feature 'Пользователь, находясь на странице вопроса, может написать ответ на вопрос', %q{
  I'd like to write an answer for question direct on the question show page.
  The question page should show a question answers also.
} do

  given(:user) {create(:user, email: 'user@test.com', password: '12345678')}
  given(:question) {create(:question)}

  scenario 'Authenticated create an answer using the question show page', js: true do
    sign_in(question.user)

    visit question_path(question)
    fill_in(:answer_body, with: 'Some new answer')
    click_on 'Answer'

    expect(current_path).to eq question_path(question)

    within '.answers' do
      expect(page).to have_content 'Some new answer'
    end
  end

  scenario 'Authenticated user creates answer with blank fields', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Only the authenticated user can c_reate answers' do
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user tries to give a impermissible answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in(:answer_body, with: ' ')

    click_on 'Answer'

    expect(page).to have_content "Body is invalid"
  end

  scenario 'Unauthenticated user tries to give a impermissible answer' do
    visit question_path(question)
    fill_in(:answer_body, with: ' ')

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end