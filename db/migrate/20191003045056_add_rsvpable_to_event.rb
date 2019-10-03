class AddRsvpableToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :rsvpable, :boolean
  end
end
