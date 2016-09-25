class StudentRoomsController < ApplicationController
    before_action :logged_user, only: [:show, :edit, :update, :destroy, :index]
    before_action :set_student_room, only: [:show, :edit, :update, :destroy]

    # GET /student_rooms
    # GET /student_rooms.json
    def index
        @student_rooms = StudentRoom.all
    end

    # GET /student_rooms/1
    # GET /student_rooms/1.json
    def show
    end

    # GET /student_rooms/new
    def new
        @student_room = StudentRoom.new
    end

    # GET /student_rooms/1/edit
    def edit
    end

    # POST /student_rooms
    # POST /student_rooms.json
    def create
        @student_room = StudentRoom.new(student_room_params)

        respond_to do |format|
            if @student_room.save
                format.html { redirect_to @student_room}
                flash[:success] = "Student has been in the pending list for the room , till approval"
                format.json { render :show, status: :created, location: @student_room }
            else
                format.html { render :new }
                format.json { render json: @student_room.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /student_rooms/1
    # PATCH/PUT /student_rooms/1.json
    def update
        respond_to do |format|
            if @student_room.update(student_room_params)
                format.html { redirect_to @student_room}
                flash[:success] = "Updated the room-student details"
                format.json { render :show, status: :ok, location: @student_room }
            else
                format.html { render :edit }
                format.json { render json: @student_room.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /student_rooms/1
    # DELETE /student_rooms/1.json
    def destroy
        @student_room.destroy
        respond_to do |format|
            flash[:success] = "Student was succesfully removed from the room"
            format.html { redirect_to room_history_display_url}
            flash[:success] = "Student was succesfully removed from the room"
        end
    end

    def enrolledshow
        @student_rooms = StudentRoom.all.map{|room| room if ((room.room_id == params[:id].to_i) && (room.status=="enrolled"))}
    end

    def pendingshow
        @student_rooms = StudentRoom.all.map{|room| room if ((room.room_id == params[:id].to_i) && (room.status=="pending"))}
    end

    def complete
        if params[:Enrollment]
            StudentRoom.where("id=?",params[:student_room_ids]).update_all(["status=?", "enrolled"])
            redirect_to roomhistorydisplayinstructor_url
        else
            StudentRoom.where("id=?",params[:student_room_ids]).delete_all
            redirect_to roomhistorydisplayinstructor_url
        end  
    end

    def room_history_display
        if logged_in?
            subset = params[:subset]
            if subset == "pending"
                @student_rooms = StudentRoom.where(user_id:current_user.id, status:"pending")
            elsif subset == "enrolled"
                @student_rooms = StudentRoom.where(user_id:current_user.id, status:"enrolled")
            elsif subset == "completed"
                @student_rooms = StudentRoom.where(user_id:current_user.id, status:"completed")
            else
                @student_rooms = StudentRoom.all.map{|room| room if (room.user_id == current_user.id)}
            end
        else
            redirect_to login_path
        end 
    end  

    def get_student_history
        if logged_in?
            if current_user.utype == "admin"
                user = User.find(params[:user])
                @student_rooms = StudentRoom.all.map{|room| room if (room.user_id == user.id)}
                @student = user
            else
                redirect_to unauthorized_url 
            end
        else
            redirect_to login_path
        end 
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_room
        @student_room = StudentRoom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_room_params
        params.require(:student_room).permit(:user_id, :room_id, :grade)
    end

    def logged_user
        unless logged_in?
            redirect_to login_url
        end
    end
end
