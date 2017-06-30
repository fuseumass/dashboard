class RenamingReorderingRemovingEventApplicationVariables < ActiveRecord::Migration[5.0]
  def change
    drop_table :event_applications

    create_table :event_applications do |t|
      t.integer :user_id
      t.string :application_status, default: 'undecided'
      t.string :name
      t.string :email
      t.string :phone
      t.string :age
      t.string :sex
      t.string :university
      t.string :major
      t.string :grad_year
      t.boolean :food_restrictions
      t.text :food_restrictions_info
      t.string :t_shirt
      t.binary :resume_file
      t.string :resume_file_name
      t.string :linkedin
      t.string :github
      t.boolean :previous_hackathon_attendance
      t.boolean :transportation
      t.string :transportation_location
      t.string :programmer_type_list, array:true, default: '{}'
      t.string :programming_skills_list, array:true, default: '{}'
      t.boolean :interested_in_hardware_hacks, default: false
      t.string :interested_hardware_hacks_list, array:true, default: '{}'
      t.text :how_did_you_hear_about_hackumass
      t.text :future_hardware_for_hackumass
      t.boolean :waiver_liability_agreement

      t.timestamps
    end
  end
end
