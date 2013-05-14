class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			session[:user_id] = user.id
			redirect_to home_path, notice: "You are Signed in"
		else
			render :new
		end
	end
end