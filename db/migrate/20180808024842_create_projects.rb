class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :description
      t.string :link
      t.string :team_members

      t.timestamps
    end
  end
end
