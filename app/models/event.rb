class Event < ApplicationRecord
  # TODO: Add a bunch of checks here
  # after_validation :remove_image_repeat
  validates_presence_of :start_time, :location, :title, :description
  has_many :event_attendances
  has_many :users, through: :event_attendances
  def self.to_csv
		CSV.generate do |csv|

			csv << Event.attribute_names

			Event.find_each do |event|
				csv << event.attributes.values
		  	end
		end
	end
end
