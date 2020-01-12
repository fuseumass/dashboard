class AddScoreToJudgement < ActiveRecord::Migration[5.2]
  def change
    add_column :judgements, :score, :integer
  end
end
