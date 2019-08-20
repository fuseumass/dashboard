class DeleteUnneededFieldsInEventApplications < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_applications, :linkedin_url, :string
    remove_column :event_applications, :github_url, :string
    remove_column :event_applications, :prev_attendance, :boolean
    remove_column :event_applications, :programming_skills, :string
    remove_column :event_applications, :hardware_skills, :string
    remove_column :event_applications, :referral_info, :text
    remove_column :event_applications, :future_hardware_suggestion, :text
  end
end
