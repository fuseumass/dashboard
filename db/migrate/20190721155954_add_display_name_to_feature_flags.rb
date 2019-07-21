class AddDisplayNameToFeatureFlags < ActiveRecord::Migration[5.2]
  def change
    add_column :feature_flags, :display_name, :string
  end
end
