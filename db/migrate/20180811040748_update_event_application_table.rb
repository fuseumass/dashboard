class UpdateEventApplicationTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :event_applications

    create_table :event_applications do |t|
      t.timestamps
      t.integer :user_id
      t.string :status, default: 'undecided'
      t.boolean :flag, default: false
      t.string :name
      t.string :phone
      t.string :age
      t.string :sex
      t.string :university
      t.string :major
      t.string :grad_year
      t.boolean :food_restrictions
      t.text :food_restrictions_info
      t.string :resume_file_name
      t.string :resume_content_type
      t.integer :resume_file_size
      t.datetime :resume_updated_at
      t.string :t_shirt_size
      t.string :linkedin_url
      t.string :github_url
      t.boolean :prev_attendance
      t.string :programming_skills, array: true, default: '{}'
      t.string :hardware_skills, array: true, default: '{}'
      t.text :referral_info
      t.text :future_hardware_suggestion
      t.boolean :waiver_liability_agreement
    end
  end
end
