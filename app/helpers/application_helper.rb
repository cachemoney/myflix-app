module ApplicationHelper
	require 'digest/md5'

	def options_for_video_reviews(selected=nil)
		options_for_select((1..5).map {|num| [pluralize(num, "Star"), num]}, selected)
	end

	def gravatar_pic_url(user)
		hash = Digest::MD5.hexdigest(user.email.downcase)
		"http://www.gravatar.com/avatar/#{hash}?s=40"
	end

	def is_current_user_friend?(friend)
		current_user.friends.include?(friend).blank?
	end
end
