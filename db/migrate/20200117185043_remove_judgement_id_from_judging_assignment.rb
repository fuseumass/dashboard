class RemoveJudgementIdFromJudgingAssignment < ActiveRecord::Migration[5.2]
  def change
    remove_column :judging_assignments, :judgement_id
    add_column :judging_assignments, :project_id, :integer
  end
end
