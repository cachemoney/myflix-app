class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		if @user.save
			session[:user_id] = @user.id
			AppMailer.welcome_email(@user).deliver
			redirect_to home_path, notice: "You are Signed in and email sent to: #{@user.email}"
		else
			render :new
		end
	end

	def show
  	@user = User.find(params[:id])
    @reviews = @user.reviews		
	end
end