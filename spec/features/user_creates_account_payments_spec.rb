require 'spec_helper'

feature 'Visitor signs up and makes a payment', {js: true, driver: :selenium, vcr: true} do
	background do
		visit register_path
		@alice = Fabricate.attributes_for(:user)
	end

	scenario 'with valid user info and valid payment info' do
		fill_user_fields_valid(@alice)
		fill_credit_card_fields('4242424242424242')
		click_button 'Sign Up'
		page.should	have_content("You are Signed in and your CC has been charged, an email has been sent to: #{@alice[:email]}")
	end
	scenario 'with valid user info and invalid payment info' do
		fill_user_fields_valid(@alice)
		fill_credit_card_fields('4000000000000002')
		click_button 'Sign Up'
		page.should	have_content("Your card was declined")
	end
	scenario 'with invalid user info and valid payment info' do
		fill_user_fields_invalid(@alice)
		fill_credit_card_fields('4242424242424242')
		click_button 'Sign Up'
		page.should	have_content("Invalid user information. Please check the errors below")
	end
	
	scenario 'with invalid user info and invalid payment info' do
		fill_user_fields_invalid(@alice)
		fill_credit_card_fields('4242424242424242')
		click_button 'Sign Up'
		page.should	have_content("Invalid user information. Please check the errors below")
	end

	def fill_credit_card_fields(card_number)
		fill_in "credit-card-number", with: card_number
		fill_in	"security-code", with: '123'
		select "6 - June", from: 'date_month'
		select "2015", from: 'date_year'
	end

	def fill_user_fields_valid(user)
		fill_in "user[email]", with: user[:email]
		fill_in "user[password]", with: user[:password]
		fill_in	"user[full_name]", with: user[:full_name]
	end

	def fill_user_fields_invalid(user)
		fill_in "user[email]", with: user[:email]
		fill_in	"user[full_name]", with: user[:full_name]		
	end

end