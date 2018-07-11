class AddResumeFileSizeToEventApplications < ActiveRecord::Migration[5.1]
  def change
      add_column :event_applications, :resume_file_size, :integer
  end
end
