json.extract! event, :id, :title, :description, :location, :time, :image, :created_by, :created_at, :updated_at
json.url event_url(event, format: :json)
