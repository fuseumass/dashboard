class RenameEmailMarketingConsentToMatchNamingConvention < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :emailMarketingConsent, :email_marketing_consent
  end
end
