class FriendshipsController < ApplicationController
	before_filter	:require_user

	def index
		@friends = current_user.friends
	end
end