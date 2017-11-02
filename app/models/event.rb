class Event < ApplicationRecord
  # TODO: Add a bunch of checks here
  after_validation :remove_image_repeat
  validates_presence_of :time, :location, :title, :description

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
                    path: 'event-images/:filename',
                    s3_credentials: {
                      bucket: 'hackumass-v-assets',
                      access_key_id: 'AKIAJXQREHQP2AIJXVFQ',
                      secret_access_key: '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',
                      s3_region: 'us-east-1'
                    }

  validates_attachment :image,
                        content_type: {content_type: ['image/png', 'image/jpeg', 'image/jpg', 'image/gif', 'image/svg']},
                        size: {in: 0...2.megabytes}


end
