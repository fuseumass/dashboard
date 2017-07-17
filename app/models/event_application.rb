class EventApplication < ApplicationRecord
  # ASSOCIATION:
    # Links event_application to user:
    belongs_to :user
end
