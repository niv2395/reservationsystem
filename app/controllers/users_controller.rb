class UsersController < ApplicationController
	before_action :logged_user, only: [:edit, :update, :newadmin, :newinstructor, :index, :show]
	# before_action :logged_in_user, only: [:edit, :update]

	def show
		@user = User.find(params[:id])
	end

	def index
		subset = params[:subset]
		if current_user.utype == "admin"
			if subset == "all"
				@users = User.all
			elsif subset == "admins"
				@users = User.where(utype:"admin")
			elsif subset == "instructors"
				@users = User.where(utype:"instructor")
			elsif subset == "students"
				@users = User.where(utype:"student")
			else
				@users = User.all
			end				
		else 
			# Need to change it to an unauthorized page
			redirect_to unauthorized_url
			# respond_to do |format|
			# 	format.html {redirect_to :controller => 'static_pages', :action => 'unauthorized'}
			# end
		end
	end

	def viewadmins
		if current_user.utype == "admin"
			@users = User.where(utype:"admin")
		else 
			# Need to change it to an unauthorized page
			redirect_to unauthorized_url
			# respond_to do |format|
			# 	format.html {redirect_to :controller => 'static_pages', :action => 'unauthorized'}
			# end
		end
	end

	def viewinstructors
		if current_user.utype == "admin"
			@users = User.where(utype:"instructor")
		else 
			# Need to change it to an unauthorized page
			redirect_to unauthorized_url
			# respond_to do |format|
			# 	format.html {redirect_to :controller => 'static_pages', :action => 'unauthorized'}
			# end
		end
	end

	def viewstudents
		if current_user.utype == "admin"
			@users = User.where(utype:"student")
		else 
			# Need to change it to an unauthorized page
			redirect_to unauthorized_url
			# respond_to do |format|
			# 	format.html {redirect_to :controller => 'static_pages', :action => 'unauthorized'}
			# end
		end
	end

	def newstudent
		@user = User.new
	end

	def newadmin
		@user = User.new
	end

	#def newinstructor
		#@user = User.new
	#end

	def create
		@user = User.new(check_user_params)
		if @user.save
			unless logged_in?
				flash[:success] = "Welcome to the Reservation System!"
				log_in @user
				redirect_to @user
			else 
				redirect_to current_user
			end
		else
			unless logged_in?
				render 'newstudent'
			else
				# redirect_to(:back)
			end
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(check_user_params)
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		user = User.find(params[:id])
		room_count = Room.where(user_id:user.id).count
		if room_count > 0
			flash[:danger] = "Cannot delete an instructor associated with a room"
			redirect_to user
		else 
			if user.safe_destroy
				redirect_to users_url
			else
				flash[:danger] = "Cannot delete the super admin"
				redirect_to user
			end
		end
	end

	private
	def check_user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation, :utype, :ph_number, :address)
	end

	def logged_user
		unless logged_in?
			redirect_to login_url
		end
	end
end
