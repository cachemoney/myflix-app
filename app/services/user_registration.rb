class UserRegistration
	attr_accessor :user
	attr_reader	:token, :invite_token

	def initialize(user, token, invite_token)
		@token = token
		@user = user
		@invite_token = invite_token
	end

	def charge_card
		StripeWrapper::Charge.create(amount: 999, currency: 'usd', card: @token, description: @user.email)
	end

	def register_user
		@user.save
		handle_invitation if @invite_token.present?
		AppMailer.delay.welcome_email(@user)
	end

	private

		def handle_invitation
			invitation = Invite.where(token: @invite_token).first
			@user.follow(invitation.inviter)
			invitation.inviter.follow(@user)
			invitation.update_column(:token, nil)
		end

end