class AddTagToJudgements < ActiveRecord::Migration[5.2]
  def change
    add_column :judgements, :tag, :string, :null => true
  end
end
