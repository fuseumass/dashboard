class Event < ApplicationRecord
  # TODO: Add a bunch of checks here
  # after_validation :remove_image_repeat
  validates_presence_of :start_time, :location, :title, :description
  has_many :event_attendances
  has_many :users, through: :event_attendances
end
