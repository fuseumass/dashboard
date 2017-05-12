class HardwareCheckout < ApplicationRecord
	validates_presence_of :user_email

	belongs_to :user, foreign_key: 'user_id'
	belongs_to :hardware_item, foreign_key: 'item_id'
end
