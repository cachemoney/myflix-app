class RelationshipsController < ApplicationController
	before_filter	:require_user

	def index
		@relationships = current_user.following_relationships
	end

	def destroy
		relationship = Relationship.find(params[:id])
		relationship.destroy if relationship.follower == current_user
		redirect_to people_path
	end

	# def create
	#   @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
	#   if @friendship.save
	#     flash[:notice] = "Added friend."
	#     redirect_to people_path
	#   else
	#     flash[:error] = "Unable to add friend."
	#     redirect_to user_path(@friendship.friend)
	#   end
	# end

end