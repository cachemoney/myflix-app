class QueueItem < ActiveRecord::Base
	belongs_to	:user
	belongs_to	:video

	delegate :category, to: :video

	def video_title
		video.title
	end

	def rating
		review = Review.where(user_id: user_id,video_id: video_id).first
		review.rating if review
	end

	def category_name
		category.title
	end

end