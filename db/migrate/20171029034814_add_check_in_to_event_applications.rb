class AddCheckInToEventApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :event_applications, :check_in, :boolean, default: false
  end
end
