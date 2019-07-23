require 'rails_helper'

feature 'Author of a question can choice the best answer. ' do

  describe  'NOT the author authenticated user ' do
    scenario 'can see the Star image near the ranked Answer body'
    scenario 'can NOT see the Star button on the page'
  end

  describe  'Author of a question' do
    given!(:question) {create(:question)}
    background {sign_in(question.user)}

    scenario 'can see the Star image near the ranked Answer body' do
      create(:answer, :ranked_true, question: question)

      visit question_path(question)
      expect(page).to have_selector('img#img-star')
    end
    scenario 'can NOT see the Star image near the unranked Answer body' do
      create(:answer, question: question)

      visit question_path(question)
      expect(page).not_to have_selector('img#img-star')
    end
    scenario 'can see the Unstar instead Star button if Answer ranked.' do
      create(:answer, :ranked_true, question: question)

      visit question_path(question)
      expect(page).not_to have_link('🌟 Star')
      expect(page).to have_link('Unstar')

    end
    scenario 'can see the Star button  if Answer unranked.' do
      create(:answer, question: question)

      visit question_path(question)
      expect(page).to have_link('🌟 Star')
    end
    scenario 'only ONE ranked answer per question can be.' do
      create(:answer, :ranked_true, question: question)
      expect{create(:answer, :ranked_true, question: question)}.to raise_error(StandardError)
    end
    scenario 'can create ANY number of not ranked answers.' do
      create(:answer, question: question)
      expect{create(:answer, question: question)}.not_to raise_error
    end
    scenario 'can star the answer.' do
      create(:answer, question: question)

      visit question_path(question)
      click_link('🌟 Star')

      expect(page).not_to have_link('🌟 Star')
      expect(page).to have_selector('img#img-star')
    end
    scenario 'can unstar the answer.'
    scenario 'ranked answer MUST be first in the answers list.'
  end

  describe 'Unauthenticated user ' do
    scenario 'can see the Star image near the ranked Answer body'
    scenario 'can NOT see the Star button on the page'
  end
end
