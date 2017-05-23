class AddMissingVariableToEventApplications < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_applications, :food_restrictions, :string

    add_column :event_applications, :email, :string, after: 'name'
    add_column :event_applications, :phone, :string, after: 'email'
    add_column :event_applications, :age, :string, after: 'phone'
    add_column :event_applications, :sex, :string, after: 'age'
    add_column :event_applications, :food_restrictions, :boolean, after: 'grad_year'
    add_column :event_applications, :food_restrictions_text, :text, after: 'food_restrictions'
    add_column :event_applications, :t_shirt, :string, after: 'food_restrictions_text'
    add_column :event_applications, :resume, :string, after: 't_shirt'
    add_column :event_applications, :linkedin, :string, after: 'resume'
    add_column :event_applications, :github, :string, after: 'linkedin'
    add_column :event_applications, :challengepost_username, :string, after: 'github'
    add_column :event_applications, :previous_hackathon_attendance, :boolean, after: 'challengepost_username'
    add_column :event_applications, :transportation, :boolean, after: 'previous_hackathon_attendance'
    add_column :event_applications, :transportation_from_where, :string, after: 'transportation'
    add_column :event_applications, :type_of_programmer_list, :string, array:true, default: '{}', after: 'transportation_from_where'
    add_column :event_applications, :programming_skills_list, :string, array:true, default: '{}', after: 'type_of_programmer_list'
    add_column :event_applications, :are_you_interested_in_hardware_hacks, :boolean, after: 'programming_skills_list'
    add_column :event_applications, :interested_hardware_list, :string, array:true, default: '{}', after: 'are_you_interested_in_hardware_hacks'
    add_column :event_applications, :how_did_you_hear_about_hackumass, :text, after: 'interested_hardware_list'
    add_column :event_applications, :future_hardware_for_hackumass, :text, after: 'how_did_you_hear_about_hackumass'
    add_column :event_applications, :do_you_have_a_team, :boolean, after: 'future_hardware_for_hackumass'
    add_column :event_applications, :team_name, :string, after: 'do_you_have_a_team'
    add_column :event_applications, :waiver_liability_agreement, :boolean, after: 'team_name'
  end
end
