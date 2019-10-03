class AddEventIdToEventAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :event_attendances, :event_id, :integer
  end
end
