class AddLocationToHardwareItems < ActiveRecord::Migration[5.2]
  def change
    add_column :hardware_items, :location, :string
  end
end
