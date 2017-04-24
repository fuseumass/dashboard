class HardwareItem < ApplicationRecord
  validates_presence_of :name, :count, :category
  validates_numericality_of :count
  validates_uniqueness_of :upc


end
