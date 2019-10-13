class UpdatePrizesInProjects < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :prizes, :json, default: []
  end
end
