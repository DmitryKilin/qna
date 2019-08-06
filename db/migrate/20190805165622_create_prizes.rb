class CreatePrizes < ActiveRecord::Migration[5.2]
  def change
    create_table :prizes do |t|
      t.string :praise, default: ''

      t.timestamps
    end
  end
end
