class AddMaxSeatsToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :max_seats, :integer
  end
end
