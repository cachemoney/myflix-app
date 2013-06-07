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
	end

	describe "PUT udpate" do
		let!(:alice) { Fabricate(:user) }		
		before do
			post :create, email: alice.email
			get :edit, id: alice.reload.password_reset_token			
		end

		context "with unexpired reset time" do
			it "udpates users password upon reset" do

				put :update, user: alice
				controller(SessionsController) do
					post :create, email: alice.email, password: "bermuda"
					expect(response).to redirect_to(home_path)
				end
			end
			it "redirects to root page"
		end

		context "with expired password reset verification email" do
			it "doest not update password"
			it "redirects to new password reset path"
		end
	end

end