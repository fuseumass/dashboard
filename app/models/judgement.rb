class Judgement < ApplicationRecord

	belongs_to :project
	belongs_to :user

	validates :project_id, presence: true
	validates :user_id, presence: true

	# Generating CSV for all judgements
	def self.to_csv
		CSV.generate do |csv|

			csv << Judgement.attribute_names

			Judgement.find_each do |j|
				csv << j.attributes.values
			end
		end
	end
end
