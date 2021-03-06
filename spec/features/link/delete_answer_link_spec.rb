require 'rails_helper'

feature 'User can delete Answer Links. ' do
  given(:user) { create(:user) }
  given!(:answer) {create(:answer)}
  given!(:question) { create(:question, answers: [answer]) }
  given!(:link) {create(:link, linkable: answer)}

  scenario 'Authenticated author CAN delete a link' do
    sign_in(answer.user)
    visit question_path(answer.question)

    expect(page).to have_link('Delete link')
  end

  scenario 'Authenticated NOT an author can NOT delete a link' do
    sign_in(user)
    visit question_path(answer.question)

    expect(page).not_to have_link('Delete link')
  end

  scenario 'Unauthenticated user can NOT delete a link' do
    visit question_path(answer.question)

    expect(page).not_to have_link('Delete link')
  end
end