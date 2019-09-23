class CreateCustomRsvp < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_rsvps do |t|
        t.json :answers
    end
    add_reference :custom_rsvps, :user, foreign_key: true
  end
end
