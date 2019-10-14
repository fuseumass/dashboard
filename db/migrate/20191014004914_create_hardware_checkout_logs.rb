class CreateHardwareCheckoutLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :hardware_checkout_logs do |t|
      t.references :user, foreign_key: true
      t.references :hardware_item, foreign_key: true
      t.string :action

      t.timestamps
    end
  end
end
