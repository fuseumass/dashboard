class MentorshipRequest < ApplicationRecord
	validates_presence_of :user, :title, :status, :urgency
	# validates :help_type, format: {with: /\S/, message: "Please choose one."}
	belongs_to :user
end
