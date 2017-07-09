json.extract! event, :id, :title, :description, :location, :time, :created_by, :thumbnail, :created_at, :updated_at
json.url event_url(event, format: :json)
