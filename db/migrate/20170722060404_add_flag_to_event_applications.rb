class AddFlagToEventApplications < ActiveRecord::Migration[5.0]
  def change
  	add_column :event_applications, :flag, :boolean, :default => false 
  end
end
