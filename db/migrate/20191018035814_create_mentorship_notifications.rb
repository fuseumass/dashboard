class CreateMentorshipNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :mentorship_notifications do |t|
      t.references :user, foreign_key: true
      t.json :tech, array: true, default: []
      t.boolean :all

      t.timestamps
    end
  end
end
