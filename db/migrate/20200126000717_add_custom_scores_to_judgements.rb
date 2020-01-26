class AddCustomScoresToJudgements < ActiveRecord::Migration[5.2]
  def change
    add_column :judgements, :custom_scores, :json
  end
end
