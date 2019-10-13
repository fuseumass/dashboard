class UpdatePrizesWonArrayInProjects < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :prizes_won, :json, array: true, default: []
  end
end
