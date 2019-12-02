require 'rails_helper'

feature 'It can a comments be added. ' do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given(:question1) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authorized user can comment question and all subscribes can see it.', js: true do
    Capybara.using_session('user1') do
      sign_in(user1)
      visit question_path(question)
    end

    Capybara.using_session('user2') do
      sign_in(user2)
      visit question_path(question)
    end

    Capybara.using_session('user1') do
      within '.question .new-comment' do
        fill_in :comment_body, with: 'My comment'
        click_on 'Comment'
      end
      within '.question .comments-list' do
        expect(page).to have_content 'My comment'
      end
    end
  end

  scenario 'Authorized user can comment answer and all subscribes can see it.', js: true do
    Capybara.using_session('user1') do
      sign_in(user1)
      visit question_path(answer.question)
    end

    Capybara.using_session('user2') do
      sign_in(user2)
      visit question_path(answer.question)
    end

    Capybara.using_session('user1') do
      within '.answers .new-comment' do
        fill_in :comment_body, with: 'My comment'
        click_on 'Comment'
      end
      within '.answers .comments-list' do
        expect(page).to have_content 'My comment'
      end
    end

    Capybara.using_session('user2') do
      within '.answers .comments-list' do
        expect(page).to have_content 'My comment'
      end
    end
  end

  scenario 'Authorized user can comment question and comment does not appear on others question page', js: true do
    # Полезно одновременно проверить страницу другого вопроса
    Capybara.using_session('user1') do
      sign_in(user1)
      visit question_path(question)
    end

    Capybara.using_session('user2') do
      sign_in(user2)
      visit question_path(question1)
    end

    Capybara.using_session('user1') do
      within '.question .new-comment' do
        fill_in :comment_body, with: 'My comment'
        click_on 'Comment'
      end
      within '.question .comments-list' do
        expect(page).to have_content 'My comment'
      end
    end

    Capybara.using_session('user2') do
      within '.question' do
        expect(page).to have_no_content 'My comment'
      end
    end
  end

  scenario 'It shows an error message when user tries add a blank comment. ', js: true do
    sign_in(user1)
    visit question_path(question)

    within '.question .new-comment' do
      fill_in :comment_body, with: ''
      click_on 'Comment'
    end

    within '.notifications' do
      expect(page).to have_content "Body can't be blank"
    end
  end
end
