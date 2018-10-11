class Project < ApplicationRecord
	after_validation :remove_repeats_err_msg
	before_create :rename_file
	before_update :rename_file

	validates_presence_of :title, :description, :team_members, :inspiration, :does_what, :built_how, :challenges, :accomplishments, :learned, :next, :built_with, :prizes, message: '%{attribute} can\'t be blank.'
	validates_uniqueness_of :title, message: '%{attribute} has already been taken.'

	belongs_to :user

	has_attached_file :projectimage,
										path: 'project/:filename'

	validates_attachment :projectimage,
											 content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png'],
																			 message: 'Image type is not supported.' },
											 size: { less_than: 10.megabyte,
															 message: 'Image file must be under 10MB in size.' }

	def rename_file
		unless projectimage_file_name.blank? || title.blank?
      extension = projectimage_file_name.gsub(/.*\./, '')
      projectimage.instance_write :file_name, "#{title}.#{extension}"
		end
	end

	def remove_repeats_err_msg
		errors.delete(:projectimage) unless errors[:projectimage].blank?
	end

end
