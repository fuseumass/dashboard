class UpdateAssignmentIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :judging_assignments, name: "index_judging_assignments_on_user_id_and_project_id"
    add_index :judging_assignments, ["user_id", "project_id", "tag"], :unique => true
  end
end
