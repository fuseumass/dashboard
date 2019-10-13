class UpdatePrizesInProjects < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :prizes
<<<<<<< HEAD
    add_column :projects, :prizes, :json, default: []
=======
    add_column :projects, :prizes, :json, array: true, default: []
>>>>>>> modify migration for prod environment -- WILL DELETE PRIZE SELECTIONS FOR PROJECT
  end
end
