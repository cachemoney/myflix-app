class InvitesController < ApplicationController
	before_filter	:require_user

	def new
		@invite = Invite.new
	end

	def create

		@invite = Invite.new(inviter: current_user, 
												invitee_email: params[:invites][:invitee_email],
												full_name: params[:invites][:full_name])
		@invite_message = params[:invites][:message]
		if @invite.save
			AppMailer.delay.invite_email(@invite, @invite_message)
			flash[:success] = "You have notified #{@invite.full_name} to join MyFlix"
			redirect_to new_invite_path
		else
			render	:new
		end
	end

end