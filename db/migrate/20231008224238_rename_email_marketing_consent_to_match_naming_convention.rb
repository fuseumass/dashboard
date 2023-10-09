class RenameEmailMarketingConsentToMatchNamingConvention < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :emailMarketingConsent, :non_transactional_email_consent
  end
end
