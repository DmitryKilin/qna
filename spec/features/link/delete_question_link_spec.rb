require 'rails_helper'

feature 'User can delete Question Links. ' do
  given(:user) { create(:user, email: 'user@test.com', password: '12345678') }
  given!(:question) {create(:question)}
  given!(:link) {create(:link, linkable: question)}

  scenario 'Authenticated author CAN delete a link' do
    sign_in(question.user)
    visit question_path(question)

    expect(page).to have_link('Delete link')
  end

  scenario 'Authenticated NOT an author can NOT delete a link' do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_link('Delete link')
  end

  scenario 'Unauthenticated user can NOT delete a link' do
    visit question_path(question)

    expect(page).not_to have_link('Delete link')
  end
end