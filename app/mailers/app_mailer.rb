class AppMailer < ActionMailer::Base
	def notify_new_review(user, review)

	end

	def welcome_email(user)
	  @user = user
	  @url = 'http://localhost:3000/sign_in'
	  email_with_name = "#{@user.full_name} <#{@user.email}>"
	  mail(:to => email_with_name, :subject => "Welcome to My Awesome Site")
	end
end