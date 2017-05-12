class RemoveItemUpcFromHardwareCheckouts < ActiveRecord::Migration[5.0]
  def change
    remove_column :hardware_checkouts, :user_email
    remove_column :hardware_checkouts, :item_upc
    remove_column :hardware_checkouts, :checked_out_by
  end
end
