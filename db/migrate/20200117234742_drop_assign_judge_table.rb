class DropAssignJudgeTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :judging_assignments
  end
end
