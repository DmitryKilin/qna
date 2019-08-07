require 'rails_helper'

feature 'Author of a question can choice the best answer. ' do

  describe  'NOT the author authenticated user ' do
    given!(:user) {create(:user)}
    given!(:question) {create(:question)}
    given!(:ranked_answer){create(:answer, ranked: true, question: question)}
    given!(:answer){create(:answer, question: question)}
    given!(:prize){create(:prize, question: question, user: question.user)}

    background {sign_in(user)}

    scenario 'can see the Star image near the ranked Answer body' do
      visit question_path(question)
      expect(page).to have_selector('img#img-reward')
    end
    scenario 'can NOT see the Star button on the page' do
      visit question_path(question)
      expect(page).not_to have_link('🌟 Star')
    end
    scenario 'can NOT see the Unstar button on the page' do
      visit question_path(question)
      expect(page).not_to have_link('Unstar')
    end
    scenario 'can create an answer' do
      visit question_path(question)
      expect(page).to have_selector('form.answer-form')
    end
  end

  describe  'Author of a question. ' do
    given!(:question) {create(:question)}
    given!(:prize){create(:prize, question: question)}

    background {sign_in(question.user)}

    context 'Answer is ranked.' do
      given!(:answer){create(:answer, ranked: true, question: question)}

      scenario 'can see the Star image near the ranked Answer body' do
        visit question_path(question)
        expect(page).to have_selector('img#img-reward')
      end

      scenario 'can see the Unstar instead Star button if Answer ranked.' do
        visit question_path(question)
        expect(page).not_to have_link('🌟 Star')
        expect(page).to have_link('Unstar')
      end

      scenario 'can unstar the answer.', js: true do
        visit question_path(question)
        click_link('Unstar')
        expect(page).not_to have_link('Unstar')
        expect(page).not_to have_selector('img#img-reward')
      end

      scenario 'only ONE ranked answer per question can be.' do
        expect{create(:answer, :ranked_true, question: question)}.to raise_error
      end
    end

    context 'Answer is NOT ranked.' do
      given!(:answer){create(:answer, question: question)}

      scenario 'can NOT see the Star image near the unranked Answer body' do
        visit question_path(question)
        expect(page).not_to have_selector('img#img-reward')
      end

      scenario 'can see the Star button  if Answer unranked.' do
        visit question_path(question)
        expect(page).to have_link('🌟 Star')
      end

      scenario 'can create ANY number of not ranked answers.' do
        expect{create(:answer, question: question)}.not_to raise_error
      end

      scenario 'can star the answer.', js: true do
        visit question_path(question)
        click_link('🌟 Star')
        expect(page).not_to have_link('🌟 Star')
        expect(page).to have_selector('img#img-star')
      end
    end


    context 'That is one unranked and one ranked answer.' do
      given!(:answer_unranked) {create(:answer, question: question)}
      given!(:answer_ranked){create(:answer, ranked: true, question: question)}

      scenario 'ranked answer MUST be first in the answers list.' do
        visit question_path(question)
        expect(page.body.index(answer_ranked.body)).to be < page.body.index(answer_unranked.body)
      end
    end

  end

  describe 'Unauthenticated user. ' do
    given!(:question) {create(:question)}
    given!(:answer){create(:answer, ranked: true, question: question)}
    given!(:prize){create(:prize, question: question)}

    scenario 'can see the Star image near the ranked Answer body' do
      visit question_path(question)
      expect(page).to have_selector('img#img-reward')
    end
    scenario 'can NOT see the Star button on the page' do
      visit question_path(question)
      expect(page).not_to have_link('🌟 Star')
    end
    scenario 'can NOT see the Unstar button on the page' do
      visit question_path(question)
      expect(page).not_to have_link('Unstar')
    end
    scenario 'can NOT create an answer' do
      visit question_path(question)
      expect(page).not_to have_selector('form.answer-form')
    end
  end
end
