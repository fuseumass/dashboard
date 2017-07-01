class RemoveProgrammerType < ActiveRecord::Migration[5.0]
  def change
    remove_column :event_applications, :programmer_type_list, :string
  end
end
