class AddMessageToHardwareCheckoutLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :hardware_checkout_logs, :message, :string
  end
end
