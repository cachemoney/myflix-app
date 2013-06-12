require 'spec_helper'

feature "User invites friend to join" do
	scenario "invites friend to create an account" do

		alice = Fabricate(:user)
		bob = Fabricate.attributes_for(:user)
		sign_in(alice)
		clear_emails
		visit new_invite_path
		fill_in  "invites[full_name]", with: bob[:full_name]
		fill_in "invites[invitee_email]", with: bob[:email]
		click_button "Send Invitation"
		open_email(bob[:email])
		current_email.body.should have_content("Please, join this really cool site")
		current_email.click_link 'Register'
		find_field('user[email]').value.should eq bob[:email]
		fill_in "user[password]", with: bob[:password]
		fill_in	"user_full_name", with: bob[:full_name]
		click_button "Sign Up"
		page.should	have_content("You are Signed in and email sent")
		# Check Friendships for inviter
		visit people_path
		page.should have_link(alice.full_name)
		# Check Friendship for invitee
		visit sign_out_path
		sign_in(alice)
		visit	people_path
		page.should have_link(bob[:full_name])
	end
end