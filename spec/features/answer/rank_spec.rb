require 'rails_helper'

feature 'Author of a question can choice the best answer. ' do
  given!(:answer) {create(:answer)}

  describe  'Not the author authenticated user ' do

  end

  describe  'Author ' do
    before {sign_in(answer.user)}

    scenario 'can see the Star button near each Answer his own.' do
      visit question_path(answer.question)
      expect(page).to have_link('🌟 Star')
    end

    scenario 'can not see the Star button near Answer others own.'
    scenario 'can star the answer.'
    scenario 'can unstar the answer.'
  end

  describe 'Unauthenticated user ' do

  end
end
