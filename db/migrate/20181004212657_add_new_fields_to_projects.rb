class AddNewFieldsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :inspiration, :string
    add_column :projects, :does_what, :string
    add_column :projects, :built_how, :string
    add_column :projects, :challenges, :string
    add_column :projects, :accomplishments, :string
    add_column :projects, :learned, :string
    add_column :projects, :next, :string
    add_column :projects, :built_with, :string
  end
end
