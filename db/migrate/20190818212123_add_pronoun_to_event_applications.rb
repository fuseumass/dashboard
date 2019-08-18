class AddPronounToEventApplications < ActiveRecord::Migration[5.2]
  def change
    add_column :event_applications, :pronoun, :string
  end
end
