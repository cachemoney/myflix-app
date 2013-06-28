require 'spec_helper'

feature "User invites friend to join"  do
	background do
		@alice = User.create(full_name: "Alice Doe", email: "alice@example.com", password: "password")
		@bob = Fabricate.attributes_for(:user)
		@charlie = Fabricate(:user)

		visit sign_in_path
		fill_in "email", with: @alice.email
		fill_in	"password", with: @alice.password
		click_button	"Sign in"
	end

	scenario "invites friend to create an account" do
		clear_emails
		visit new_invite_path
		fill_in  "invites[full_name]", with: @bob[:full_name]
		fill_in "invites[invitee_email]", with: @bob[:email]
		click_button "Send Invitation"
		open_email(@bob[:email])
		current_email.body.should have_content("Please, join this really cool site")
		current_email.click_link 'Register'
		find_field('user[email]').value.should eq @bob[:email]
		fill_in "user[password]", with: @bob[:password]
		fill_in	"user_full_name", with: @bob[:full_name]
		fill_credit_card_fields('4242424242424242')

		click_button "Sign Up"
		page.should	have_content("You are Signed in and your CC has been charged, an email has been sent to: #{@bob[:email]}")
		# Check Friendships for inviter
		visit people_path
		page.should have_link(@alice.full_name)
		# Check Friendship for invitee
		visit sign_out_path
		sign_in(@alice)
		visit	people_path
		page.should have_link(@bob[:full_name])
	end

	def fill_credit_card_fields(card_number)
		fill_in "card-number", with: card_number
		fill_in	"card-cvc", with: '123'
		select "6 - June", from: 'date_month'
		select "2016", from: 'date_year'
	end
end