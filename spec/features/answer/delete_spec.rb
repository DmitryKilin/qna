require 'rails_helper'

feature 'Автор может удалить свой ответ, но не может удалить чужой ответ' do
  given(:answer) {create(:answer)}
  given(:not_an_author) {create(:user, email: 'not_an_author@test.com', password: '12345678')}

  scenario 'tries delete his answer' do
    sign_in(answer.user)

    visit answer_path(answer)
    click_on 'Delete'

    expect(page).to have_content "Answer have been deleted!"
  end

  scenario 'tries delete some others answer' do
    sign_in(not_an_author)

    visit answer_path(answer)
    click_on 'Delete'

    expect(page).to have_content "You can delete yours answers only!"
  end

  scenario "Нужно добавить проверку что у неавторизованного даже нет ссылки на удаление. Unauthorised user can't see the delete button." do
    visit answer_path(answer)

    expect(page).not_to have_content('Delete')
  end

end