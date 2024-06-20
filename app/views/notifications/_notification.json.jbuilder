json.extract! notification, :id, :table_id, :field_id, :value, :send_to, :created_at, :updated_at
json.url notification_url(notification, format: :json)
