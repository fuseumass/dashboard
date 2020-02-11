class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :provider, :string, :null => false, :default => "email"
    change_table(:users) do |t|
      ## Required       t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""
      t.boolean  :allow_password_change, default: true

      ## Tokens
      t.json :tokens
    end
  end
end