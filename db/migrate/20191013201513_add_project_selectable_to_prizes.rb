class AddProjectSelectableToPrizes < ActiveRecord::Migration[5.2]
  def change
    add_column :prizes, :project_selectable, :boolean, default: true
  end
end
