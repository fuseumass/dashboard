json.extract! hardware_item, :id, :name, :count, :link, :category, :available, :upc, :image, :created_at, :updated_at
json.url hardware_item_url(hardware_item, format: :json)
