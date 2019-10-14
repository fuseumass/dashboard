class UpdatePrizesInProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :prizes
    add_column :projects, :prizes, :json, array: true, default: []
  end
end
