class AddPaperclipToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :projectimage_file_name, :string
    add_column :projects, :projectimage_content_type, :string
    add_column :projects, :projectimage_file_size, :integer
    add_column :projects, :projectimage_updated_at, :datetime
  end
end
