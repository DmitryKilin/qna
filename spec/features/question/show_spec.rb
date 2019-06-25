require 'rails_helper'

feature 'Пользователь может просматривать вопрос и ответы к нему.' do
  given(:question) {create(:question, :with_answers)}

  scenario 'A User can see a question and a answers on it' do
    visit question_path(question)

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    question.answers.all? { |answer| expect(page).to have_content answer.body }
  end
end
