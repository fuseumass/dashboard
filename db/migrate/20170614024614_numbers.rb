class Numbers < ActiveRecord::Migration[5.0]
  def change
    add_column :event_applications, :accepted_applicants, :integer, default: 0
    add_column :event_applications, :rejected_applicants, :integer, default: 0
    add_column :event_applications, :waitlisted_applicants, :integer, default: 0
  end
end
