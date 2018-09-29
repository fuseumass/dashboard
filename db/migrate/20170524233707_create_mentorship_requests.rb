class CreateMentorshipRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :mentorship_requests do |t|
      t.integer :user_id
      t.integer :mentor_id
      t.string :title
      t.string :type
      t.string :status
      
      t.timestamps
    end
  end
end
