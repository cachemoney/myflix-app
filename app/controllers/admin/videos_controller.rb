class Admin::VideosController < AdminsController
	before_filter :require_user
	before_filter	:require_admin

	def new
		@video = Video.new
		@categories = Category.all
	end

	def create
		@video = Video.new(params[:video])
		@categories = Category.all
		
		if @video.save
			flash[:success] = "You have successfull saved #{@video.title}, enter another one"
			redirect_to new_admin_video_path
		else
			flash[:error] = "Unable to save video, try again"
			render :new
		end
		
	end

	private

	def require_admin
		if !current_user.admin?
			flash[:error] = "You are not authorized"
			redirect_to home_path
		end
	end

end