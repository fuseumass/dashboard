class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.string :location
      t.string :time
      t.string :created_by
      t.string :thumbnail

      t.timestamps
    end
  end
end
