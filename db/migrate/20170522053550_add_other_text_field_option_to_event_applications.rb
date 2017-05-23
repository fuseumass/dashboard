class AddOtherTextFieldOptionToEventApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :event_applications, :programming_skills_other_field, :string
  end
end
