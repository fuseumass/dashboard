class MentorshipRequest < ApplicationRecord
	validates_presence_of :user, :title, :status, :urgency
	has_attached_file :screenshot
	validates_attachment_content_type :screenshot, :content_type => /image/
	serialize :tech, Array
	belongs_to :user
	
	ransacker :name_case_insensitive, type: :string do
		arel_table[:name].lower
	  end
end
