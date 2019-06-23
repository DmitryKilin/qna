require 'rails_helper'

feature 'User can write an answer for question', %q{
  I'd like to write an answer for question direct on the question show page.
  The question page should show a question answers also.
} do

  given(:user) { User.create!(email: 'user@test.com', password: '12345678') }

  # Не могу понять почему не работает!:
  # background do
  #   question = create(:question, :with_answers)
  #   visit question_path(question)
  # end

  scenario do
    sign_in(user)

    question = create(:question, :with_answers)
    visit question_path(question)

    fill_in(:answer_body, with: 'Some new answer')
    click_on 'Answer'

    visit question_path(question)

    expect(page).to have_content 'Some new answer'
  end
end

feature 'User can create answer', %q{
  In order to answer
  As an authenticated user
  I'd like to be able to answer
} do


  scenario 'Unauthenticated user tries to answer' do
    question = create(:question, :with_answers)
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end