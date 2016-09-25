json.array!(@student_rooms) do |student_room|
  json.extract! student_room, :id, :user_id, :room_id, :grade
  json.url student_room_url(student_room, format: :json)
end
