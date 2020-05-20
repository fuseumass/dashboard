class MentorshipRequest < ApplicationRecord
	validates_presence_of :user, :title, :status, :urgency
	has_attached_file :screenshot
	validates_attachment_content_type :screenshot, :content_type => /image/
	belongs_to :user

	def urgency_str
		if urgency == 0
			return "Not Urgent"
		elsif urgency == 1
			return "Mildly Urgent"
		elsif urgency == 2
			return "Urgent"
		else
			return "Drastically Urgent"
		end
	end

end
