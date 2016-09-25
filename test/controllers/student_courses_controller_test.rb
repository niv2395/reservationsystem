require 'test_helper'

class StudentRoomsControllerTest < ActionController::TestCase
  setup do
    @student_room = student_rooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_rooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_room" do
    assert_difference('StudentRoom.count') do
      post :create, student_room: { room_id: @student_room.room_id, grade: @student_room.grade, user_id: @student_room.user_id }
    end

    assert_redirected_to student_room_path(assigns(:student_room))
  end

  test "should show student_room" do
    get :show, id: @student_room
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_room
    assert_response :success
  end

  test "should update student_room" do
    patch :update, id: @student_room, student_room: { room_id: @student_room.room_id, grade: @student_room.grade, user_id: @student_room.user_id }
    assert_redirected_to student_room_path(assigns(:student_room))
  end

  test "should destroy student_room" do
    assert_difference('StudentRoom.count', -1) do
      delete :destroy, id: @student_room
    end

    assert_redirected_to student_rooms_path
  end
end
