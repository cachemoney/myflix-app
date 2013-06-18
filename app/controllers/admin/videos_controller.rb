class Admin::VideosController < AdminsController

	def new
		@video = Admin::Video.new
	end

	def create
		@video = Admin::Video.new(params[:video])
	end
end