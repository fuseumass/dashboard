class AddPrizeFieldToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :prize, :string
  end
end
