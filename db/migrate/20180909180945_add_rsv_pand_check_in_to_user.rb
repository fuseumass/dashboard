class AddRsvPandCheckInToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :rsvp, :boolean, default: false
    add_column :users, :check_in, :boolean, default: false
  end
end
