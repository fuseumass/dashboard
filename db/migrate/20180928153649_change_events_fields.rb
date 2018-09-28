class ChangeEventsFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :time, :start_time
    add_column :events, :end_time, :datetime
    add_column :events, :host, :string
  end
end
