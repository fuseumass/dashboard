class AddTagToJudgingAssignments < ActiveRecord::Migration[5.2]
  def change
    add_column :judging_assignments, :tag, :string, :null => true
  end
end
