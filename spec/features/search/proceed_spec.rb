require 'sphinx_helper'

feature 'Guests and users can search a phrase in Questions, Answers, Users and Comments  ' do
  given!(:question1) { create(:question, title: "The slings and arrows of outrageous fortune")}
  given!(:question2) { create(:question, title: 'Or to take arms against a sea of troubles')}
  given!(:answer1) { create(:answer, body: "The slings and arrows of outrageous fortune")}
  given!(:answer2) { create(:answer, body: 'Or to take arms against a sea of troubles')}
  given!(:comment1) { create(:comment, :comment_question, body: "The slings and arrows of outrageous fortune")}
  given!(:comment2) { create(:comment, :comment_question, body: 'Or to take arms against a sea of troubles')}
  given!(:user1) { create(:user, email: "user1@tst.com")}
  given!(:user2) { create(:user, email: "user2@tst.com")}
  before { visit search_get_search_path }

  describe 'Searching in ', js: true, sphinx: true do
    scenario 'a questions' do
      ThinkingSphinx::Test.run do
        within 'form' do
          fill_in 'Search:', with: 'to take arms'
          check "question_flag"
          click_on 'Search'
        end
        expect(current_path).to eq search_get_search_path
        within '#question' do
          expect(page).to have_content question2.id
          expect(page).to_not have_content question1.id

        end
      end
    end

    scenario 'an answer' do
      ThinkingSphinx::Test.run do
        within 'form' do
          fill_in 'Search:', with: 'to take arms'
          check "answer_flag"
          click_on 'Search'
        end
        expect(current_path).to eq search_get_search_path
        within '#answer' do
          expect(page).to have_content answer2.id
          expect(page).to_not have_content answer1.id

        end
      end
    end

    scenario 'a comment' do
      ThinkingSphinx::Test.run do
        within 'form' do
          fill_in 'Search:', with: 'to take arms'
          check "comment_flag"
          click_on 'Search'
        end
        expect(current_path).to eq search_get_search_path
        within '#comment' do
          expect(page).to have_content comment2.id
          expect(page).to_not have_content comment1.id

        end
      end
    end

    scenario 'a user' do
      ThinkingSphinx::Test.run do
        within 'form' do
          fill_in 'Search:', with: 'user2'
          check "user_flag"
          click_on 'Search'
        end
        expect(current_path).to eq search_get_search_path
        within '#user' do
          expect(page).to have_content user2.id
          expect(page).to_not have_content user1.id
        end
      end
    end
  end
end