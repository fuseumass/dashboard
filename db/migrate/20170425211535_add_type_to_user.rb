class AddTypeToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :user_type, :string, :default => 'attendee'
  end
end
