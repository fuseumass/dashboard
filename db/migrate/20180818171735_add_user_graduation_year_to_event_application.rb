class AddUserGraduationYearToEventApplication < ActiveRecord::Migration[5.2]
  def change
    add_column :event_applications, :education_lvl, :string
  end
end
