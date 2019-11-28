require 'rails_helper'

feature 'Пользователь может зарегистрироваться в системе', %q{
  In order to use all service features I want to register
} do
  scenario "Visitor fills correct the register form, clicks the 'Sign up' button and redirects to the confirmation page" do
    visit new_user_registration_path
    fill_in('Email', with: 'user@test.com')
    fill_in('Password', with: '12345678')
    fill_in('Password confirmation', with: '12345678')
    click_on('Sign up')
    expect(page).to have_content"Welcome! You have signed up successfully."
  end

  scenario "Visitor writes impermissible data in the register form, clicks the 'Sign up' button and redirects to the confirmation page" do
    visit new_user_registration_path
    fill_in('Email', with: 'wrong_user_test.com')
    fill_in('Password', with: '12345678')
    fill_in('Password confirmation', with: '12345678')
    click_on('Sign up')
    expect(page).to have_content"Email is invalid"
  end
end