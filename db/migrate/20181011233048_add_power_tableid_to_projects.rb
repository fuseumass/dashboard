class AddPowerTableidToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :power, :boolean
    add_column :projects, :table_id, :integer
  end
end
