class AddGenderPronounToEventApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :event_applications, :gender, :string
  end
end
