class DropActiveStorage < ActiveRecord::Migration[5.2]
  def change
    drop_table :active_storage_attachments
    drop_table :active_storage_blobs
  end
end
