class UsersController < ApplicationController
	before_filter :set_invite_id, only: [:new]

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
		if @user.save
			session[:user_id] = @user.id
			AppMailer.welcome_email(@user).deliver
			befriend_inviter(@user) if Invite.find_by_invitee_email(@user.email)
			redirect_to home_path, notice: "You are Signed in and email sent to: #{@user.email}"
		else
			render :new
		end
	end

	def show
  	@user = User.find(params[:id])
    @reviews = @user.reviews		
	end

	def set_invite_id
		@invite_id = params[:invite_id] || nil
	end

	private

	def befriend_inviter(invitee)
		invite = Invite.find_by_invitee_email(invitee.email)
		invitee_leader = Relationship.create(leader: invitee, follower: invite.inviter )
		inviter_leader = Relationship.create(leader: invite.inviter, follower: invitee )
	end
end