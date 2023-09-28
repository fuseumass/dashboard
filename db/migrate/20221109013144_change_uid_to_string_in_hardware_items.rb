class ChangeUidToStringInHardwareItems < ActiveRecord::Migration[5.2]
  def change
    change_column :hardware_items, :uid, :string
  end
end
