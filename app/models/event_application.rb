class EventApplication < ApplicationRecord
    validates_presence_of :name, :university, :major, :grad_year
    validates :name, length: { minimum: 2 }
    validates :grad_year, length: { is: 4 }
end
