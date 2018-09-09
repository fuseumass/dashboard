class HardwareItem < ApplicationRecord
  searchkick
  validates_presence_of :name, :count, :category
  validates_numericality_of :count
  validates_uniqueness_of :upc

  has_many :hardware_checkouts, dependent: :destroy
  has_many :users, through: :hardware_checkouts

  def is_available?
    if count > 0
      'Yes'
    else
      'No'
    end
  end


  def to_csv
    attributes = %w{name upc}
    CSV.generate do |csv|
      item = self
        count = item.count
        while count >= 1
          csv << item.attributes.values_at(*attributes)
          count -= 1
        end
    end
  end

end
