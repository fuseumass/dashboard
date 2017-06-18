class Number2 < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_applications, :accepted_applicants, :integer
    remove_column :event_applications, :rejected_applicants, :integer
    remove_column :event_applications, :waitlisted_applicants, :integer

    add_column :event_applications, :accepted_applicants, :integer, default: 0
    add_column :event_applications, :rejected_applicants, :integer, default: 0
    add_column :event_applications, :waitlisted_applicants, :integer, default: 0
  end
end
