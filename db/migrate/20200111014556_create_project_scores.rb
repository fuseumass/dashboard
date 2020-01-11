class CreateProjectScores < ActiveRecord::Migration[5.2]
  def change
    create_table :project_scores do |t|
      t.integer :project_id
      t.integer :judge_id
      t.string :score

      t.timestamps
    end
    add_index :project_scores, :project_id
    add_index :project_scores, :judge_id
    add_index :project_scores, :score
  end
end
