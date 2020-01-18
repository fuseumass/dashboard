class AddUserIdToJudgingAssignments < ActiveRecord::Migration[5.2]
  def change
    add_column :judging_assignments, :user_id, :integer
  end
end
