class UpdatePrizesWonArrayInProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :prizes_won
    add_column :projects, :prizes_won, :json, array: true, default: []
  end
end
