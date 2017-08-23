json.extract! event, :id, :title, :description, :location, :time, :created_by, :created_at, :updated_at, :image
json.url event_url(event, format: :json)
