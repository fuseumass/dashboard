class Event < ApplicationRecord
  # TODO: Add a bunch of checks here
  # after_validation :remove_image_repeat
  validates_presence_of :start_time, :location, :title, :description
  has_many :event_attendances
  has_many :users, through: :event_attendances

  def numberRSVPd
    counter = 0
    EventAttendance.where(event_id: self.id).each do |ea|
      begin
        user = User.find_by(id: ea.user_id) 
          if user.is_attendee?
            counter += 1 
          end 
      rescue => exception
      end
    end 
    return counter      
  end
end
