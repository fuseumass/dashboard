class Project < ApplicationRecord
	validates_presence_of :title, :description, :team_members
	validates_uniqueness_of :title
end
