class AddRankToAnAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :ranked, :boolean, default: false
  end
end
