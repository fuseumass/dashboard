class EditProjectFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :prize, :string
    add_column :projects, :prizes, :string, array:true, default: '{}'
  end
end
