class AddQuestionRefToPrizes < ActiveRecord::Migration[5.2]
  def change
    add_reference :prizes, :question
  end
end
