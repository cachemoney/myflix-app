class PasswordResetsController < ApplicationController

	def create
		@user = User.find_by_email(params[:email])
		send_password_reset(@user) if @user
		redirect_to confirm_password_reset_path
	end

	def edit
		 @user = User.find_by_password_reset_token(params[:id])
		 redirect_to invalid_token_path unless @user
	end

	def update
	  @user = User.find_by_password_reset_token!(params[:id])
	  if @user.password_reset_sent_at < 2.hours.ago
	    redirect_to new_password_reset_path, :alert => "Password reset has expired."
	  elsif @user.reset_password(params[:user][:password])
	    redirect_to root_url, :notice => "Password has been reset!"
	  else
	    redirect_to invalid_token_path
	  end		
	end


	private

	def send_password_reset(user)
	  user.set_password_reset_token
	  user.set_password_reset_sent_at
	  AppMailer.delay.password_reset(user)
	end

end