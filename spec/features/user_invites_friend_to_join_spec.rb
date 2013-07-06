require 'spec_helper'

feature "User invites friend to join" do
	background do
	end

	scenario "invites friend to create an account", {js: true, driver: :selenium} do
		clear_emails
		@alice = User.create(full_name: "Alice Doe", email: "alice@example.com", password: "password")
		@bob = Fabricate.attributes_for(:user)
		sign_in(@alice)	
		invite_a_friend(@bob)

		friend_accepts_invitation(@bob)

		# page.should	have_content("You are Signed in and your CC has been charged, an email has been sent to: #{@bob[:email]}")
		# Check Friendships for friend
		friend_signs_in(@bob)
		visit people_path
		page.should have_link(@alice.full_name)
		# Check Friendship for inviter
		visit sign_out_path
		sign_in(@alice)
		visit	people_path
		page.should have_link(@bob[:full_name])
	end

	def invite_a_friend(user)
		visit new_invite_path
		fill_in  "invites[full_name]", with: user[:full_name]
		fill_in "invites[invitee_email]", with: user[:email]
		click_button "Send Invitation"
		sign_out
	end

	def friend_signs_in(user)
		visit sign_in_path
    fill_in "Email Address", with: user[:email]
    fill_in "Password", with: user[:password]
    click_button "Sign in"
	end

	def friend_accepts_invitation(user)		
		open_email(user[:email])
		current_email.body.should have_content("Please, join this really cool site")
		current_email.click_link 'Register'
		find_field('user[email]').value.should eq user[:email]
		fill_in "user[password]", with: user[:password]
		fill_in	"user_full_name", with: user[:full_name]
		fill_credit_card_fields('4242424242424242')

		click_button "Sign Up"	
	end

	def fill_credit_card_fields(card_number)
		fill_in "credit-card-number", with: card_number
		fill_in	"security-code", with: '123'
		select "6 - June", from: 'date_month'
		select "2015", from: 'date_year'
	end

end