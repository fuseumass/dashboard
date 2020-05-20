class Project < ApplicationRecord
	after_validation :remove_repeats_err_msg
	before_create :rename_file
	before_update :rename_file

	validates_presence_of :title, :description, :inspiration, :does_what, :built_how, :challenges, :accomplishments, :learned, :next, :built_with, message: '%{attribute} can\'t be blank.'
	validates_uniqueness_of :title, message: '%{attribute} has already been taken.'

	has_many :user

	has_many :judgements, :dependent => :restrict_with_error
	has_many :judging_assignments, dependent: :delete_all

	has_attached_file :projectimage,
										path: 'project/:filename'



	validates :link,
            allow_blank: true,
            if: -> { link.present? },
            format: { with: /\G[hH][tT][tT][pP][sS]:\/\/.*/,
                      message: 'Github link must begin with \'https://\'' }



	validates_length_of :description, :maximum => 280, message: 'Maximum description length is 280.'


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

	def get_youtube_id
		url = self.youtube_link
		id = ''
		url = url.gsub(/(>|<)/i,'').split(/(vi\/|v=|\/v\/|youtu\.be\/|\/embed\/)/)
		if url[2] != nil
			id = url[2].split(/[^0-9a-z_\-]/i)
			id = id[0];
		else
			id = url;
		end
		id
	end

	# Generating CSV for all projects
	def self.to_csv
		CSV.generate do |csv|

			csv << Project.attribute_names

			Project.find_each do |project|
				csv << project.attributes.values
		  	end
		end
	end

end
