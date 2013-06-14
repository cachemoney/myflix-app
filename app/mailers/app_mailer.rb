class AppMailer < ActionMailer::Base
	def notify_new_review(user, review)

	end

	def welcome_email(user)
	  @user = user
	  @url = 'http://localhost:3000/sign_in'
	  email_with_name = "#{@user.full_name} <#{@user.email}>"
	  mail(to: @user.email, from: 'info@myflix.com' , subject: "Welcome to My Awesome Site")
	end

	def password_reset(user)
		@user = user
		mail :to => @user.email, :subject => "Password Reset", from: "info@myflix.com"
	end

	def invite_email(invitation, message)
		@invitation = invitation
		@message = message
		@url = register_with_token_url(@invitation.token)
		mail(to: @invitation.invitee_email, 
		subject: "#{@invitation.inviter.full_name} invites you to joing MyFlix",
		from: "info@myflix.com")
	end
end