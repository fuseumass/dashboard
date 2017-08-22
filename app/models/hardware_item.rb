class HardwareItem < ApplicationRecord
  searchkick
  validates_presence_of :name, :count, :category
  validates_numericality_of :count
  validates_uniqueness_of :upc

  has_many :hardware_checkouts, dependent: :destroy
  has_many :users, through: :hardware_checkouts

  after_validation :remove_image_repeat

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


  # Because of how paperclips works, when validating for the size of the
  # image, it will create two identical error that are link to different
  # symbols. This method will remove one of the symbol there by removing
  # the duplication.
  private
  def remove_image_repeat
    if errors.keys.include?(:image_file_size)
      errors.delete(:image_file_size)
    end

    if errors.keys.include?(:image_content_type)
      errors.delete(:image_content_type)
    end
  end

  has_attached_file :image,
                    storage: :s3,
                    s3_protocol: 'https',
                    path: 'hardware-images/:filename',
                    s3_credentials: {
                      :bucket => 'hackumass-v-asset',
                        :access_key_id => 'AKIAIZAVSFUILF4TAG4Q',
                      :secret_access_key => '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',
                      :s3_region => 'us-east-1'
                    }

  validates_attachment :image,
                       content_type: {content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif', 'image/svg']},
                       size: {in: 0...2.megabytes}

end
