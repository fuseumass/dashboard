class ChangeUpcToUid < ActiveRecord::Migration[5.2]
  def change
    rename_column :hardware_item, :upc, :uid
  end
end
