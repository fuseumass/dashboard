class HardwareCheckout < ApplicationRecord

	validates_presence_of :user
	validates_presence_of :hardware_item

	belongs_to :user
	belongs_to :hardware_item
end
