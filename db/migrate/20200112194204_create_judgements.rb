class CreateJudgements < ActiveRecord::Migration[5.2]
  def change
    create_table :judgements do |t|

      t.timestamps
    end
  end
end
