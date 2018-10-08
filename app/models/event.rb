class Event < ApplicationRecord
  # TODO: Add a bunch of checks here
  # after_validation :remove_image_repeat
  validates_presence_of :start_time, :location, :title, :description
end
