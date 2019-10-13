class UpdateTechDefaultInProjects < ActiveRecord::Migration[5.2]
  def change
    change_column_default(
      :projects,
      :tech,
      from: "{}",
      to: [])
  end
end
