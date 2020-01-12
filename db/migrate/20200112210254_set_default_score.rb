class SetDefaultScore < ActiveRecord::Migration[5.2]
  def change
    change_column :judgements, :score, :integer, default: -1
  end
end
