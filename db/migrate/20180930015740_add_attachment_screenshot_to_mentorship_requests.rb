class AddAttachmentScreenshotToMentorshipRequests < ActiveRecord::Migration[5.2]
  def self.up
    change_table :mentorship_requests do |t|
      t.attachment :screenshot
    end
  end

  def self.down
    remove_attachment :mentorship_requests, :screenshot
  end
end
