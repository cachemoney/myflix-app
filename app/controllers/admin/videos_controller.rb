class Admin::VideosController < AdminsController

	def new
		@video = Video.new
		@categories = Category.all
	end

	def create
		@video = Video.new(params[:video])
		@categories = Category.all
		
		if @video.save
			flash[:success] = "You have successfull saved #{@video.title}, enter another one"
		else
			flash[:error] = "Unable to save video, try again"
		end
		redirect_to new_admin_video_path
	end
end