class RemoveTeamMembersFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :team_members, :string
  end
end
