class RemoveOldVariablesFromEventApplication < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_applications, :rsvp, :boolean
    remove_column :event_applications, :check_in, :boolean
    remove_column :event_applications, :resume_file_size, :integer
    remove_column :event_applications, :email, :string
    remove_column :event_applications, :resume_file, :binary
    remove_column :event_applications, :resume_file_name, :string
    remove_column :event_applications, :interested_in_hardware_hacks, :boolean
    remove_column :event_applications, :interested_hardware_hacks_list, :string

    add_column :event_applications, :resume, :binary
  end
end
