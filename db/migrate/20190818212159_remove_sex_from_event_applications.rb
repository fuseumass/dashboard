class RemoveSexFromEventApplications < ActiveRecord::Migration[5.2]
  def change
    remove_column :event_applications, :sex, :string
  end
end
