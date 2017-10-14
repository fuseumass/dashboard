class AddRsvpToEventApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :event_applications, :rsvp, :boolean, :default => false
  end
end
