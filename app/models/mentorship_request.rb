class MentorshipRequest < ApplicationRecord
	validates_presence_of :user, :title, :status, :urgency
	serialize :tech, Array
	belongs_to :user
end
