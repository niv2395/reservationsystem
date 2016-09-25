class AddStatustoStudentRooms < ActiveRecord::Migration
  def change
  	add_column :student_rooms, :status, :string
  end
end
