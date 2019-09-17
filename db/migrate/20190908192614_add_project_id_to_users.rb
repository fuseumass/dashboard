class AddProjectIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :project_id, :integer
  end
end
