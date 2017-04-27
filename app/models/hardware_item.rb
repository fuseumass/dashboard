class HardwareItem < ApplicationRecord
  searchkick
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

  def self.to_csv
    attributes = %w{name upc}
    CSV.generate do |csv|
      all.each do |item|
        csv << item.attributes.values_at(*attributes)
      end
    end
  end


end
