require 'rails_helper'

feature 'Пользователь, находясь на странице вопроса, может написать ответ на вопрос', %q{
  I'd like to write an answer for question direct on the question show page.
  The question page should show a question answers also.
} do

  given(:user) {create(:user, email: 'user@test.com', password: '12345678')}
  given(:question) {create(:question, :with_authorship)}

  # Магия какая-то, Если раскомментить `background`, то аргументом `visit` передаётся хэлпер не `question_path(question)`,
  # a `questions_path` ?!
  # background { visit question_path(question) }

  scenario 'An user can create an answer from the question show page' do
    sign_in(question.user)

    visit question_path(question)
    fill_in(:answer_body, with: 'Some new answer')
    click_on 'Answer'

    # vkurennov 5 hours ago
    # нет, так ты просто страницу перезагружаешь получается.
    # У тебя же должно быть как: ввел ответ, нажал сохранить - ответ есть на странице.
    # Без повторного захода на страницу
    visit question_path(question)
    # Cписок ответов отображается на странице вопроса.
    # Чтобы вывести обновлённый список
    # (с включённым в него новым ответом, созданным спеком) выбрал вариант обновления страницы
    # путём повторного захода на неё, поскольку про Ajax я только слышал. :)
    #
    # save_and_open_page

    expect(page).to have_content 'Some new answer'

  end

  # scenario 'Только аутентифицированный пользователь может создавать ответы' do
  #   visit question_path(question)
  #
  #   click_on 'Answer'
  #
  #   expect(page).to have_content 'You need to sign in or sign up before continuing.'
  # end

  scenario 'User tries to give a impermissible answer' do
    sign_in(user)

    visit question_path(question)
    fill_in(:answer_body, with: ' ')

    click_on 'Answer'

    expect(page).to have_content "Answer can't be blank!"
  end
end