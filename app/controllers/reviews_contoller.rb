class ReviewsController < ApplicationController
	before_filter	:require_user
	
	def create
		video = Video.find(params[:video_id])
		review = video.reviews.build(params[:review])
		if review.save
			redirect_to video_path(video)
		else
			render 'videos/show'
		end

	end
end