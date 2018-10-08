class AddTechToMentorshipRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :mentorship_requests, :description, :string
    add_column :mentorship_requests, :tech, :string, array:true, default: '{}'
    remove_column :mentorship_requests, :help_type, :string
  end
end
