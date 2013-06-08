require 'spec_helper'

describe PasswordResetsController do

	describe	"POST create" do
		let!(:alice) { Fabricate(:user) }

		it "sends email when valid user submits email for forgotten password" do
			post :create, email: alice.email
			ActionMailer::Base.deliveries.last.to.should include(alice.email)
		end
		it "doesn't send email to a user not existing in database" do
			post :create, email: "nonexistent2_user@example.com"
			ActionMailer::Base.deliveries.last.to.should_not include("nonexistent2_user@example.com")
		end
		it "redirects to confirm password reset page" do
			post :create, email: alice.email
			expect(response).to redirect_to confirm_password_reset_path
		end

		it "sets the password reset token" do
			post :create, email: alice.email
			alice.reload.password_reset_token.should_not be_nil
		end
	end

	describe "GET edit" do
		let!(:alice) { Fabricate(:user) }

		it "sets the @user from the password reset token" do
			post :create, email: alice.email
			get :edit, id: alice.reload.password_reset_token
			expect(assigns(:user)).to be_instance_of(User)
		end

		context "with invalid token" do
			it "redirects to invalid token template" do
				alice.set_password_reset_token
				alice.set_password_reset_sent_at
				get :edit, id: alice.reload.password_reset_token + '123'
				expect(response).to redirect_to invalid_token_path
			end

	end

	describe "PUT udpate" do
		let!(:alice) { Fabricate(:user) }

		context "with unexpired reset time" do
			it "resets users password" do
				alice.set_password_reset_token
				alice.set_password_reset_sent_at
				old_password_digest = alice.password_digest
				put :update, id: alice.password_reset_token, user: { password: alice.password + '123' }
				expect(alice.reload.password_digest).to_not eq(old_password_digest)
			end
			it "redirects to root page" do
				alice.set_password_reset_token
				alice.set_password_reset_sent_at				
				put :update, id: alice.password_reset_token, user: { password: alice.password + '123' }
				expect(response).to redirect_to root_path
			end
		end


		end

		# Need to figure out to stub/mock time
		context "with expired password reset verification email" do
			it "doest not update password"
			it "redirects to new password reset path"
		end
	end

end