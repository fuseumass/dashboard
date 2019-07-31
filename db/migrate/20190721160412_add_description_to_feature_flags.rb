class AddDescriptionToFeatureFlags < ActiveRecord::Migration[5.2]
  def change
    add_column :feature_flags, :description, :string
  end
end
