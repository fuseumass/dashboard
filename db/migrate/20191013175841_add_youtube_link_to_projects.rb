class AddYoutubeLinkToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :youtube_link, :string
  end
end
