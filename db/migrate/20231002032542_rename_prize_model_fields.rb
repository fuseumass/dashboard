class RenamePrizeModelFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :prizes, :name, :award
    rename_column :prizes, :criteria, :title
  end
end
