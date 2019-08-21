class MentorshipRequest < ApplicationRecord
	validates_presence_of :user, :title, :status, :urgency
	has_attached_file :screenshot
	validates_attachment_content_type :screenshot, :content_type => /image/
	if not Rails.env.production?
		serialize :tech, Array
	end
	belongs_to :user
	
end
