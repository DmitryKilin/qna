require 'rails_helper'

feature 'User can be authorized by OAuth', %q{
  In order to to be authorized, user
  can use an alter capabilities
} do

  background { visit new_user_session_path }

  context 'Using GitHub' do
    scenario ' and correct credentials' do
      mock_auth_github
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from GitHub account.'
    end

    scenario ' and fallacious credentials' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Invalid credentials'
    end
  end

  context 'Using VKontakte' do
    scenario ' and asked the email' do
      mock_auth_vkontakte
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'enter your email for confirmation letter'
    end
  end
end
