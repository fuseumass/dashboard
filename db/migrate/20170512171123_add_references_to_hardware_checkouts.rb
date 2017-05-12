class AddReferencesToHardwareCheckouts < ActiveRecord::Migration[5.0]
  def change
    remove_column :hardware_checkouts, :user_id
    remove_column :hardware_checkouts, :item_id
    add_reference :hardware_checkouts, :user, foreign_key: true
    add_reference :hardware_checkouts, :hardware_item, foreign_key: true
  end
end
