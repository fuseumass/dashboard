class AddUrgencyToMentorshipRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :mentorship_requests, :urgency, :integer
  end
end
