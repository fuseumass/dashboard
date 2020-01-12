class DropProjectScoreTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :project_scores
  end
end
