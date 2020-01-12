class AddUserIdToJudgements < ActiveRecord::Migration[5.2]
  def change
    add_column :judgements, :user_id, :integer
  end
end
