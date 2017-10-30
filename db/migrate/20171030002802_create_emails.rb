class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :subject
      t.string :message
      t.string :mailing_list
      t.string :status
      t.string :sent_by

      t.timestamps
    end
  end
end
