class SessionsController < ApplicationController

	def new
		redirect_to home_path if current_user
	end
	
	def create
		user = User.where(email: params[:email]).first
		if user && user.authenticate(params[:password]) #has_secure_password helper
			session[:user_id] = user.id
			redirect_to home_path, notice: "You are Signed in"
		else
			flash[:error] = "Invalid Email or Password"
			redirect_to sign_in_path
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path, notice: "You are Signed Out."
	end
end