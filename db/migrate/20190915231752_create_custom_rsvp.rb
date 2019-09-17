class CreateCustomRsvp < ActiveRecord::Migration[5.2]
  def change
    remove_column :custom_rsvps, :answers, :string
    add_column :custom_rsvps, :answers, :json
  end
end
