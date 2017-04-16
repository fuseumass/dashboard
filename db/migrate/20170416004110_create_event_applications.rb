class CreateEventApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :event_applications do |t|
      t.integer :user_id
      t.string :name
      t.string :university
      t.string :major
      t.string :grad_year
      t.string :food_restrictions

      t.timestamps
    end
  end
end
