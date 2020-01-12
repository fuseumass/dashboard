class DropExtraJudgingFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :score
    remove_column :projects, :judge_id
  end
end
