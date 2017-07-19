class HardwareSkills < ActiveRecord::Migration[5.0]
  def change
    add_column :event_applications, :hardware_skills_list, :string, array:true, default: '{}'
  end
end
