class HardwareCheckoutLog < ApplicationRecord
  belongs_to :user
  belongs_to :hardware_item
end
