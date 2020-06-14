class DeviseTokenAuthEditUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string, :null => false, :default => "email"
    change_table(:users) do |t|
      t.string :uid, :null => false, :default => ""

      ## Tokens
      t.json :tokens
    end
  end
end