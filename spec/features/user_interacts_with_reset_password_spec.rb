require 'spec_helper'

feature "User uses resets password feature" do
	scenario "User resets password and logs in w/ new password" do
		alice = Fabricate(:user)
		clear_emails
		visit new_password_reset_path
		fill_in "email", with: alice.email
		click_button "Send Email"
		page.should have_content("We have send an email with instructions to reset your password")
		open_email(alice.email)
		current_email.body.should have_content(alice.reload.password_reset_token)
		visit edit_password_reset_url(alice.reload.password_reset_token)
		page.should have_content("Reset Your Password")
		fill_in "user[password]", with: alice.password + '123'
		click_button "Reset Password"
		page.should have_content("Password has been reset!")
		visit sign_in_path
		fill_in "email", with: alice.email
		fill_in "password", with: alice.password + '123'
		click_button "Sign in"
		page.should have_content("You are Signed in")
	end

end