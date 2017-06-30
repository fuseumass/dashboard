class AddAttachmentResumeToEventApplications < ActiveRecord::Migration
  def self.up
    remove_column :event_applications, :accepted_applicants, :integer
    remove_column :event_applications, :rejected_applicants, :integer
    remove_column :event_applications, :waitlisted_applicants, :integer
    remove_column :event_applications, :resume_file, :binary
    remove_column :event_applications, :resume_file_name, :string

    change_table :event_applications do |t|
      t.attachment :resume
    end
  end

  def self.down
    add_column :event_applications, :accepted_applicants, :integer
    add_column :event_applications, :rejected_applicants, :integer
    add_column :event_applications, :waitlisted_applicants, :integer
    add_column :event_applications, :resume_file, :binary
    add_column :event_applications, :resume_file_name, :string
    remove_attachment :event_applications, :resume
  end
end
