class AddUserRefToPrizes < ActiveRecord::Migration[5.2]
  def change
    add_reference :prizes, :user, foreign_key: true
  end
end
