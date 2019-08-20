class ModifyDefaultValueForCustomFieldsInEventApplications < ActiveRecord::Migration[5.2]
  def change
    change_column_default(
      :event_applications,
      :custom_fields,
      from: "{}",
      to: nil)
  end
end
