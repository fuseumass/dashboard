json.extract! event_application, :id, :user_id, :name, :university, :major, :grad_year, :food_restrictions, :created_at, :updated_at
json.url event_application_url(event_application, format: :json)
