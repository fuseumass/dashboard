class Prize < ApplicationRecord
	validates_presence_of :name, :description, :criteria, :sponsor, :priority
end
