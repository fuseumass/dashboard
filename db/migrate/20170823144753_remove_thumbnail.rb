class RemoveThumbnail < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :thumbnail, :string
  end
end
