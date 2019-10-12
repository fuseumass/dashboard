class AddCheckedInToEventAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :event_attendances, :checked_in, :boolean
  end
end
