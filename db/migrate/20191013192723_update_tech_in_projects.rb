class UpdateTechInProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :tech
    add_column :projects, :tech, :json, default: '{}'
  end
end
