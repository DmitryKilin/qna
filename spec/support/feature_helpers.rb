module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path

    fill_in('Email', with: 'user@test.com')
    fill_in('Password', with: '12345678')
    click_on 'Log in'
  end
end