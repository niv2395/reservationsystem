class AnnouncementsController < ApplicationController
	before_action :logged_user, only: [:new, :index]

 	def new
 		if current_user.utype == "instructor" 

			if Room.where(user_id:current_user.id).count == 0
				# instructor doesnt have any rooms, cant make an announcement
				redirect_to norooms_url
			else
				@relevant_rooms = Room.all.map{|room| [room.title, room.id] if room.user_id == current_user.id}
				@announcement = Announcement.new
			end
		elsif current_user.utype == "admin"
			@relevant_rooms = Room.all.map {|room| [room.title, room.id]}
			@announcement = Announcement.new
		else 
			redirect_to unauthorized_url
		end
  	end

  	def create
	  	@announcement = Announcement.new(check_announcement_params)
  		if @announcement.save
			flash[:success] = "Announcement posted!"
			redirect_to current_user
		else
		end
	
  	end

  	def index
  		# @announcements = Announcement.all
  		@announcements = Announcement.joins(:room).merge(Room.all).order('created_at DESC')
  		# room_id = User.find(params[:room_id])
  		# @room_announcements = Announcement.where(room_id: room_id)
  	end

  	private
	def check_announcement_params
		params.require(:announcement).permit(:title, :content, :room_id)
	end

	def logged_user
		unless logged_in?
			redirect_to login_url
		end
	end
end
