class DropExtraScoreTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :judgings
    drop_table :project_scores
  end
end
