class AddUserIdToEventAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :event_attendances, :user_id, :integer
  end
end
