class UsersController < ApplicationController

	def new
		if @invite_id
			@user_email = Invite.find(@invite_id).invitee_email
			@user = User.new(email: @user_email)
		else
			@user = User.new
		end
	end

	def create
		@user = User.new(params[:user])

		registration = UserRegistration.new(@user).register_user(params[:stripeToken],params[:invite_token])
		if registration.successful?
			session[:user_id] = @user.id
			flash[:success] = "You are Signed in and your CC has been charged, an email has been sent to: #{@user.email}"
			redirect_to home_path
		else
			flash[:error] = registration.error_message
			render	:new
		end
	end

	def show
  	@user = User.find(params[:id])
    @reviews = @user.reviews		
	end

	def new_with_invitation_token
		invitation = Invite.where(token: params[:token]).first
		if invitation
			@user = User.new(email: invitation.invitee_email, full_name: invitation.full_name)
			@invite_token = invitation.token
			render :new
		else
			redirect_to invalid_token_path
		end
	end

end