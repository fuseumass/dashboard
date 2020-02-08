class Judgement < ApplicationRecord

	belongs_to :project
	belongs_to :user

	validates :project_id, presence: true
	validates :user_id, presence: true

	# Generating CSV for all judgements
	def self.to_csv
		CSV.generate do |csv|
			
			finalKeyArr = Array.new
			keyArr = Judgement.first.attributes.keys
			customScoreArr = Judgement.first.attributes.values[6]
			customScorePos = 0
			
			finalKeyArr.push("project_name")
			finalKeyArr.push("judge first_name")
			finalKeyArr.push("judge last_name")
			
			for i in 0..keyArr.length
				if(keyArr[i] != "custom_scores" && keyArr[i] != " ")
					finalKeyArr.push(keyArr[i])
				end
				if(keyArr[i] == "custom_scores") 
					customScorePos = i
				end
			end

			finalKeyArr.delete_at(finalKeyArr.length() - 1)
			
			for key, value in customScoreArr
				finalKeyArr.push(key)
			end

			finalKeyArr.reject { |item| item.nil? || item == '' }
			csv << finalKeyArr
		  
			Judgement.find_each do |j|
			  
				valuesArr = j.attributes.values
				finalValueArr = Array.new
				customValuesArr = j.attributes.values[customScorePos]

				finalValueArr.push(j.project.title)
				finalValueArr.push(j.user.first_name)
				finalValueArr.push(j.user.last_name)

				for i in 0..valuesArr.length
					if i != customScorePos
						finalValueArr.push(valuesArr[i])
					end
				end
				finalValueArr.delete_at(finalValueArr.length() - 1)
				for key, value in customValuesArr
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
			if custom_scores[c['name']] == nil or custom_scores[c['name']] == ""
				errors.add("missing_custom_field_#{c['name']}".to_sym, "Please judge this category: #{c['name']}")
			end
		end
	end
end
