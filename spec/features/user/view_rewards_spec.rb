require 'rails_helper'

feature 'User can see his rewards' do
  given!(:question) {create(:question, :with_attachments)}
  given!(:user) {question.user}
  given!(:prize){create(:prize, question: question, user: user)}
  given!(:answer){create(:answer, ranked: true, user: user)}

  scenario 'Authorised user can see his rewards' do
    sign_in(user)

    click_on 'Rewards'

    expect(page).to have_text('You are good!')
    expect(page).to have_selector('img')
  end
end