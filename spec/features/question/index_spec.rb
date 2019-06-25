require 'rails_helper'

feature 'Пользователь может просматривать список вопросов' do
  given(:questions) {create_list(:question, 3,  :sequence)}

  scenario 'All visitors can view questions list' do
    visit questions_path(questions)

    questions.all? {|question| expect(page).to have_content question.title}
  end
end