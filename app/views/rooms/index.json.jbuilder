json.array!(@rooms) do |room|
  json.extract! room, :id, :title, :description, :start_date, :end_date, :user_id, :status
  json.url room_url(room, format: :json)
end
