require 'rails_helper'
feature 'User can sign in', %q{
  In order to ask questions
  As an authenticated user
  I'd like to be able  to sign in
} do

  # Проглядел все глаза, не пойму почему при использовании конструкции `given` в брайзере выводится,
  # что не верный пароль или пользователь. Оставил закомментчиным.
  # given(:user) { User.create!(email: 'user@test.com', password: '12345678') }
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    User.create!(email: 'user@test.com', password: '12345678')
    fill_in('Email', with: 'user@test.com')
    fill_in('Password', with: '12345678')
    click_on 'Log in'

    # save_and_open_page
    expect(page).to have_content 'Signed in successfully.'
  end
  scenario 'Unregistered user tries to sign in' do
    fill_in('Email', with: 'wrong@test.com')
    fill_in('Password', with: '12345678')
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

end