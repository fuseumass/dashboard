class RenameEmailMarketingConsentToNonTransactionalEmailConsent < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :email_marketing_consent, :non_transactional_email_consent
  end
end
