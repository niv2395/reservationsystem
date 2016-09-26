class RoomsController < ApplicationController
    before_action :logged_user, only: [:show, :edit, :update, :destroy, :index]
    before_action :set_room, only: [:show, :edit, :update, :destroy]

    # GET /rooms
    # GET /rooms.json
    def index
        # @rooms = Room.all

        if params[:search].blank?
            @rooms = Room.all.order('created_at DESC')
        elsif params[:search]
            if params[:searchby] == 'ID'
                @rooms = Room.where("id like #{params[:search]}")
            elsif params[:searchby] == 'Title'
                @rooms = Room.where("title LIKE ?","%#{params[:search]}%")
            elsif params[:searchby] == 'Description'
                @rooms = Room.where("description LIKE ?","%#{params[:search]}%")
            # elsif params[:searchby] == 'Instructor'
            #     @rooms = Room.joins(:user).merge(User.where(" name like ?","%#{params[:search]}%"))
            elsif params[:searchby] == 'Status'
                @rooms = Room.where("lower(status) = ?","#{params[:search].downcase}")
            end 
        else
            @rooms = Room.all.order('created_at DESC')
        end
    end

    # GET /rooms/1
    # GET /rooms/1.json
    def show
        @room_announcements = Announcement.where(room_id:@room.id)
    end

    # GET /rooms/new
    def new
        if current_user.utype == "admin"
            @room = Room.new
        else
            redirect_to unauthorized_url
        end
    end

    # GET /rooms/1/edit
    def edit
    end

    # POST /rooms
    # POST /rooms.json
    def create
        if current_user.utype == "admin"
            @room = Room.new(room_params)

            respond_to do |format|
                if @room.save
                    format.html { redirect_to @room }
                    flash[:success] ='Room was successfully created.'
                    format.json { render :show, status: :created, location: @room }
                else
                    format.html { render :new }
                    format.json { render json: @room.errors, status: :unprocessable_entity }
                end
            end
        else
            redirect_to unauthorized_url
        end
    end

    # PATCH/PUT /rooms/1
    # PATCH/PUT /rooms/1.json
    def update
        respond_to do |format|
            if @room.update(room_params)
                format.html { redirect_to @room}
                flash[:success] ='Room was successfully updated.'
                format.json { render :show, status: :ok, location: @room }
            else
                format.html { render :edit }
                format.json { render json: @room.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /rooms/1
    # DELETE /rooms/1.json
    def destroy
        student_count = StudentRoom.where(room_id:@room.id, status:"enrolled").count
        if student_count > 0
            flash[:danger] = "Cannot delete a room with enrolled students"
            redirect_to @room
        else      
            @room.destroy
            respond_to do |format|
                format.html { redirect_to rooms_url}
                flash[:success] ='Room was successfully destroyed.'
                format.json { head :no_content }
            end
        end
    end

    # POST /student_rooms
    # POST /student_rooms.json
    def enroll

        if (StudentRoom.where("user_id=? AND room_id=?",current_user.id,params[:id]).empty?)
            @student_room = StudentRoom.new
            @student_room.user_id = current_user.id
            @student_room.room_id = params[:id]
            @student_room.grade= 'F'
            @student_room.status = 'pending'
            respond_to do |format| 
                if @student_room.save
                    format.html { redirect_to room_history_display_url}
                    flash[:success] = "A request has been sent to admin to add you to the room."
                    format.json { render :show, status: :created, location: @student_room }
                else
                    format.html { render :index}
                    format.json { render json: @student_room.errors, status: :unprocessable_entity }
                end
            end 
        else
            redirect_to rooms_url
            flash[:success] ='Student already reserved the room.'
        end  
    end

    def roomhistorydisplayinstructor
        if logged_in?
            @rooms = Room.all.map{|room| room if (room.user_id == current_user.id)}
        else
            redirect_to login_path
        end 
    end  

    def get_instructor_history
        if logged_in?
            if current_user.utype == "admin"
                user = User.find(params[:user])
                @rooms = Room.all.map{|room| room if (room.user_id == user.id)}
                @instructor = user
            else
                redirect_to unauthorized_url 
            end
        else
            redirect_to login_path
        end 
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
        @room = Room.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
        params.require(:room).permit(:title, :description, :start_date, :end_date, :user_id, :status)
    end

    

    def logged_user
        unless logged_in?
            redirect_to login_url
        end
    end
end
