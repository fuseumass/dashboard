class CreateJudgements < ActiveRecord::Migration[5.2]
  def change
    create_table :judgements do |t|
      t.integer :score

      t.timestamps
    end
  end
end
