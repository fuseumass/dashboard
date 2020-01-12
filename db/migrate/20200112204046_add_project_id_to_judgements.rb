class AddProjectIdToJudgements < ActiveRecord::Migration[5.2]
  def change
    add_column :judgements, :project_id, :integer
  end
end
