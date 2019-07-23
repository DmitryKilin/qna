require 'rails_helper'

feature 'Author of a question can choice the best answer. ' do

  describe  'NOT the author authenticated user ' do
    scenario 'can see the Star image near the ranked Answer body'
    scenario 'can NOT see the Star button on the page'
    scenario 'can NOT see the Unstar button on the page'
  end

  describe  'Author of a question. ' do
    given!(:question) {create(:question)}
    background {sign_in(question.user)}

    context 'Answer is ranked.' do
      given!(:answer){create(:answer, :ranked_true, question: question)}

      scenario 'can see the Star image near the ranked Answer body' do
        visit question_path(question)
        expect(page).to have_selector('img#img-star')
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
        expect(page).not_to have_selector('img#img-star')
      end

      scenario 'only ONE ranked answer per question can be.' do
        expect{create(:answer, :ranked_true, question: question)}.to raise_error
      end
    end

    context 'Answer is NOT ranked.' do
      given!(:answer){create(:answer, question: question)}

      scenario 'can NOT see the Star image near the unranked Answer body' do
        visit question_path(question)
        expect(page).not_to have_selector('img#img-star')
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



    scenario 'ranked answer MUST be first in the answers list.'
  end

  describe 'Unauthenticated user. ' do
    scenario 'can see the Star image near the ranked Answer body'
    scenario 'can NOT see the Star button on the page'
    scenario 'can NOT see the Unstar button on the page'
  end
end
