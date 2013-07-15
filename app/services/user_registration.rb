class UserRegistration

	attr_reader	:error_message

	def initialize(user)
		@user = user
	end

	def register_user(stripe_token, invitation_token)
		if @user.valid?
			charge = StripeWrapper::Charge.create(amount: 999, card: stripe_token, description: @user.email)
			if charge.success?	
				@user.save
				handle_invitation(invitation_token)
				AppMailer.delay.welcome_email(@user)
				@status = :success
				self
			else
				@status = :failed
				@error_message = charge.error_message
				self
			end
		else
			@status = :failed
			@error_message = "Invalid user information. Please check the errors below"
			self
		end
	end

	def successful?
		@status == :success
	end

	private

		def handle_invitation(token)
			if token.present?
				invitation = Invite.where(token: token).first
				@user.follow(invitation.inviter)
				invitation.inviter.follow(@user)
				invitation.update_column(:token, nil)
			end
		end

end