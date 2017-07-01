class RemoveDefaultValueInBooleanValue < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_applications, :interested_in_hardware_hacks, :boolean
    add_column :event_applications, :interested_in_hardware_hacks, :boolean
  end
end
