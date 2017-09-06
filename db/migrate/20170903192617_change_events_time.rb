class ChangeEventsTime < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :time, :datetime
  end
end
