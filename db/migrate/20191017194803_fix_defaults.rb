class FixDefaults < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :tech
    remove_column :projects, :prizes
    remove_column :projects, :prizes_won
    add_column :projects, :tech, :json, array: true, default: []
    add_column :projects, :prizes, :json, array: true, default: []
    add_column :projects, :prizes_won, :json, array: true, default: []
  end
end
