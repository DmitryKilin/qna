require 'rails_helper'

feature 'User can see his rewards' do
  given(:question) {create(:question, :with_attachments)}
  given!(:prize){create(:prize, question: question)}

  background {question.answers.create(body: "Ranked answer", ranked: true, user: question.user)}
  scenario 'Authorised user can see his rewards' do
    sign_in(question.user)

    click_on 'Rewards'

    expect(page).to have_text('You are good!')
    expect(page).to have_selector('img')
  end
end