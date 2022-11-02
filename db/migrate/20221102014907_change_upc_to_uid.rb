class ChangeUpcToUid < ActiveRecord::Migration[5.2]
  def change
    rename_column :hardware_items, :upc, :uid
  end
end
