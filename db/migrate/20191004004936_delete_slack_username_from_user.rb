class DeleteSlackUsernameFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :slack_username
  end
end
