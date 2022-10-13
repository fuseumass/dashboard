class AddMlhCommunicationsToEventApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :event_applications, :mlh_communications, :boolean
  end
end
