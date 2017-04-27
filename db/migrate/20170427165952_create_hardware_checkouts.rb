class CreateHardwareCheckouts < ActiveRecord::Migration[5.0]
  def change
    create_table :hardware_checkouts do |t|
      t.integer :user_id
      t.string  :user_email
      t.integer :item_id
      t.integer :item_upc
      t.integer :checked_out_by

      t.timestamps
    end
  end
end
