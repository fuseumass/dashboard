class Prize < ApplicationRecord
	validates_presence_of :award, :description, :title, :sponsor, :priority
end
 