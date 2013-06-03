class FriendshipsController < ApplicationController
	before_filter	:require_user

	def index
		@friends = current_user.friends
	end

	def destroy
		deleted_friendship = current_user.friendships.find_by_friend_id(params[:id])
		deleted_friendship.destroy
		redirect_to people_path, notice: "You Are no longer friends with #{deleted_friendship.friend.full_name}"
	end

	def create
	  @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
	  if @friendship.save
	    flash[:notice] = "Added friend."
	    redirect_to people_path
	  else
	    flash[:error] = "Unable to add friend."
	    redirect_to user_path(@friendship.friend)
	  end
	end

end