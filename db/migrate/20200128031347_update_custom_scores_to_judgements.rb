class UpdateCustomScoresToJudgements < ActiveRecord::Migration[5.2]
  def change
    change_column_default(
      :judgements,
      :custom_scores,
      from: nil,
      to: "{}")
  end
end
