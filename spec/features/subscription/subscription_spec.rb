require 'rails_helper'

feature 'Authenticated user can subscribe for the question renewals', "
  In order to trace a question renovations
  I'd like to send a email with a new answer notifications
  to a subscribed QnA users.
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:subscription) { create(:subscription, question: question, user: user) }

  scenario 'Authenticated subscribed user', js: true do
    sign_in user
    visit question_path(question)

    expect(page).to have_link('Unsubscribe')
    expect(page).to_not have_link('Subscribe')

    click_on('Unsubscribe')

    expect(page).to_not have_link('Unsubscribe')
    expect(page).to have_link('Subscribe')
  end

end
