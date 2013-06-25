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

		if @user.valid?
			handle_payments(@user)
			if @charge.success?
				@user.save
				session[:user_id] = @user.id
				flash[:success] = "You are Signed in and your CC has been charged, an email has been sent to: #{@user.email}"
				redirect_to home_path
			else
				flash[:error] = @charge.error_message
				render	:new
			end
		else
			flash[:error] = "Unable to add You"
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
			@user = User.new(email: invitation.invitee_email)
			@invite_token = invitation.token
			render :new
		else
			redirect_to invalid_token_path
		end
	end

	private

	def handle_invitation
		if params[:invite_token].present?
			invitation = Invite.where(token: params[:invite_token]).first
			@user.follow(invitation.inviter)
			invitation.inviter.follow(@user)
			invitation.update_column(:token, nil)
		end				
	end

	def handle_payments(user)
	  # Amount in cents
	  @amount = 999
	  token = params[:stripeToken]
	  
	  @charge = StripeWrapper::Charge.create(
	    :amount     => @amount,
	    :card    		=> token
	  )

	end
end