class AddSlackToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :slack, :boolean
  end
end
