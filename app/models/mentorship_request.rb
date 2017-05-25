class MentorshipRequest < ApplicationRecord
	validates_presence_of :user, :title, :status
	#validates :help_type, format: {with: /\S/, message: "Please choose one."}
	validates_length_of :title, :maximum => 140
	belongs_to :user
end
