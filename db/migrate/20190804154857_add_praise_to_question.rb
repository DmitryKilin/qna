class AddPraiseToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :praise, :string
  end
end
