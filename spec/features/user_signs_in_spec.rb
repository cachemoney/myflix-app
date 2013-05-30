require 'spec_helper'

feature 'user signs in' do
	background do
		User.create(full_name: "Jon Doe", email: "jon@example.com", password: "password")
	end
	scenario 'with existing username' do
		visit sign_in_path
		fill_in "email", with: "jon@example.com"
		fill_in	"password", with: "password"
		click_button	"Sign in"
		page.should have_content "Welcome, Jon Doe"
	end

	scenario 'with non-existant username' do
		visit sign_in_path
		fill_in "email", with: "jon_jones@example.com"
		fill_in	"password", with: "password"
		click_button	"Sign in"
		page.should have_content "Invalid Email or Password"
	end

end