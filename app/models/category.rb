class Category < ActiveRecord::Base
	has_many :videos, order: "created_at DESC"
	validates :title, presence: true

	def recent_videos
		Video.first(6)
	end
end
