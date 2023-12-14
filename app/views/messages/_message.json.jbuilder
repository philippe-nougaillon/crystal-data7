json.extract! message, :id, :nom, :filter_id, :field_id, :body, :created_at, :updated_at
json.url message_url(message, format: :json)
