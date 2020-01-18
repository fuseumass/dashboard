class RemoveJudgingAssignmentReferences < ActiveRecord::Migration[5.2]
  def change
    remove_reference :judging_assignments, :judgement, index: true, foreign_key: true
  end
end
