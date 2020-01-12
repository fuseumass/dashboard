class CreatePrizes < ActiveRecord::Migration[5.2]
  def change
    create_table :prizes do |t|
      t.string :name
      t.string :description
      t.string :criteria
      t.string :sponsor
      t.integer :priority

      t.timestamps
    end
  end
end
