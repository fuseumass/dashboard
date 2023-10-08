class AddConsentToMarketingEmailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :emailMarketingConsent, :boolean, default: false
  end
end
