class CreateHardwareItems < ActiveRecord::Migration[5.0]
  def change
    create_table :hardware_items do |t|
      t.integer :upc
      t.string :name
      t.string :link
      t.string :category
      t.integer :count
      t.boolean :available

      t.timestamps
    end
  end
end
