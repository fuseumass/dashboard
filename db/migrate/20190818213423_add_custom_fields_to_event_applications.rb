class AddCustomFieldsToEventApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :event_applications, :custom_fields, :json
  end
end
