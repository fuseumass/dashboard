class UpdateJudgeAssignmentPrimaryKey < ActiveRecord::Migration[5.2]
  def change
    add_index :judging_assignments, ["user_id", "project_id"], :unique => true
  end
end
