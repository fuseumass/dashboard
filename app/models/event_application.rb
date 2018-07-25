class EventApplication < ApplicationRecord

  # Allows us so search through app
  # searchkick

  # Links event_application to user:
  belongs_to :user


end
