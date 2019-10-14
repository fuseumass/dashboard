class AddTechToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :tech, :string, array:true, default: '{}'
  end
end
