class Judgement < ApplicationRecord

	belongs_to :project
	belongs_to :user

	validates :project_id, presence: true
	validates :user_id, presence: true

	# Generating CSV for all judgements
	def self.to_csv
		CSV.generate do |csv|

			# @header = []
			# Judgement.attribute_names.each do |attr_name|
			# 	if attr_name == 'user_id'
			# 		@header << 'Judge Name'
			# 	elsif attr_name == 'project_id'
			# 		@header << 'Project Name'
			# 	elsif attr_name == 'custom_scores'
			# 		# TODO: Improve Display of Custom Scores
			# 		@header << 'Custom Scores'
			# 	else
			# 		@header << attr_name.titleize
			# 	end
			# end
			# csv << @header

			# Judgement.find_each do |j|
			# 	@row = []
			# 	j.attributes.keys.each do |attr|
			# 		if attr == 'project_id'
			# 			@row << Project.find_by(id: j.attributes[attr]).title
			# 		elsif attr == 'user_id'
			# 			@row << User.find_by(id: j.attributes[attr]).full_name
			# 		else
			# 			@row << j.attributes[attr]
			# 		end
			# 	end
			# 	csv << @row
			# end

			# finalKeyArr = Array.new
			# keyArr = Array.new
			# keyArr = EventApplication.first.attributes.keys
			# hashKeyArr = EventApplication.first.attributes.values.last
			# keyArrLength = keyArr.length() - 2
	  
			# finalKeyArr.push("first_name")
			# finalKeyArr.push("last_name")
			# finalKeyArr.push("email")
	  
			# for i in 0..keyArrLength 
			#   finalKeyArr.push(keyArr[i])
			# end
	  
			# for key, value in hashKeyArr
			#   finalKeyArr.push(key)
			# end
			
			finalKeyArr = Array.new
			keyArr = Judgement.first.attributes.keys
			customScoreArr = Judgement.first.attributes.values[6]

			for i in 0..keyArr.length
				if(keyArr[i] != "custom_scores")
					finalKeyArr.push(keyArr[i])
				end
			end

			for key, value in customScoreArr
				finalKeyArr.push(key)
			end

			csv << finalKeyArr
		  
	  
			Judgement.find_each do |j|
			  
				valuesArr = j.attributes.values
				finalValueArr = Array.new

				for i in 0..valuesArr.length
					if i != 6
						finalValueArr.push(valuesArr[i])
					end
				end

				for key, value in customScoreArr
					finalValueArr.push(value)
				end

		
				csv << finalValueArr
	  
			end
		
		end
	end

	validate :custom_judgements_validation

	private 

	def custom_judgements_validation
		HackumassWeb::Application::JUDGING_CUSTOM_FIELDS.each do |c|
			if custom_scores[c['name']] == nil
				errors.add("missing_custom_field_#{c['name']}".to_sym, "Please judge this category: #{c['name']}")
			end
		end
	end
end
