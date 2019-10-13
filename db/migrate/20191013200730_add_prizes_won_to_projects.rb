class AddPrizesWonToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :prizes_won, :json, default: []
  end
end
