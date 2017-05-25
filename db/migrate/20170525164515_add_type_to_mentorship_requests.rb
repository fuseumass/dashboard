class AddTypeToMentorshipRequests < ActiveRecord::Migration[5.0]
  def change
    add_column :mentorship_requests, :help_type, :string
    remove_column :mentorship_requests, :type
  end
end
