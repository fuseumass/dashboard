class Judgement < ApplicationRecord

	belongs_to :project
	belongs_to :user

	validates :project_id, presence: true
	validates :user_id, presence: true
	validates :custom_judgements_validation, presence: true

	# Generating CSV for all judgements
	def self.to_csv
		CSV.generate do |csv|

			csv << Judgement.attribute_names

			Judgement.find_each do |j|
				csv << j.attributes.values
			end
		end
	end

	private 

	def custom_judgements_validation
		HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
			if custom_fields[c['name']] == nil or custom_fields[c['name']] == '' or custom_fields[c['name']].length == 0
				errors.add("missing_custom_field_#{c['name']}".to_sym, "Please judge this category: #{c['name']}")
			end
		end
	end
end
