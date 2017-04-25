class HardwareItem < ApplicationRecord
  validates_presence_of :name, :count, :category
  validates_numericality_of :count
  validates_uniqueness_of :upc


  def is_available?
    if count > 0
      'Yes'
    else
      'No'
    end
  end


end
