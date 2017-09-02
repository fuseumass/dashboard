class ReaddImageVarible < ActiveRecord::Migration[5.0]
  def change
    add_attachment :events, :image
    add_attachment :hardware_items, :image
  end
end
