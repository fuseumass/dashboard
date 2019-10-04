class RemoveSlackFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :slack
    add_column :users, :slack_id, :string, null: true
    add_column :users, :slack_username, :string, null: true
  end
end
