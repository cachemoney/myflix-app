require 'spec_helper'

describe UsersController do

	describe "GET new" do
		# let(:user1){ Fabricate(:user) }

		it "assign new user to @user " do
			get :new
			expect(assigns(:user)).to be_instance_of(User)
		end

		it "should render new template" do
			get :new
			expect(response).to render_template :new
		end

	end

	describe "GET new_with_invitation_token" do
		it "renders the new view template" do
			invitation = Fabricate(:invite)
			get :new_with_invitation_token, token: invitation.token
			expect(response).to render_template :new
		end

		it "sets @user with invitee's email " do
			invitation = Fabricate(:invite)
			get :new_with_invitation_token, token: invitation.token
			expect(assigns(:user).email).to eq(invitation.invitee_email)			
		end
		it "sets invitation token" do
			invitation = Fabricate(:invite)
			get :new_with_invitation_token, token: invitation.token
			expect(assigns(:invite_token)).to eq invitation.token
		end
		it "redirects to expired token page for invalid tokens" do
			invitation = Fabricate(:invite)
			get :new_with_invitation_token, token: 'fskdhf'
			expect(response).to redirect_to invalid_token_path

		end
	end
	
	describe "POST create" do
		# let(:user1){ Fabricate.build(:user) }

		context "successful user sign up" do

			after { ActionMailer::Base.deliveries.clear }

			it "redirects to home_path" do
				result = double(:sign_up_result, successful?: true)
				UserRegistration.any_instance.should_receive(:register_user).and_return(result)
				post :create, user: Fabricate.attributes_for(:user)
				expect(response).to redirect_to home_path
			end

			# it "logs user in automatically" do
			# 	alice = Fabricate.build(:user)
			# 	result = double(:sign_up_result, successful?: true)
			# 	UserRegistration.any_instance.should_receive(:register_user).and_return(result)
			# 	post :create, user: alice
			# 	expect(session[:user_id]).to_not eq nil
			# end	

		end

		context "failed user sign up" do
			it "renders the :new template" do
				result = double(:sign_up_result, successful?: false, error_message: "Invalid user information. Please check the errors below")
				UserRegistration.any_instance.should_receive(:register_user).and_return(result)
        post :create, user: { email: "test@example.com" }
        expect(response).to render_template :new				
			end			

			it "sets the flash error message" do
				result = double(:sign_up_result, successful?: false, error_message: "Invalid user information. Please check the errors below")
				UserRegistration.any_instance.should_receive(:register_user).and_return(result)
				post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
				expect(flash[:error]).to eq("Invalid user information. Please check the errors below")
			end		

		end

		context "invalid User info" do
			after { ActionMailer::Base.deliveries.clear }
			
			it "does not create a user" do
        post :create, user: { email: "test@example.com" }
        expect(User.count).to eq(0)				
			end
			it "renders the :new template" do
        post :create, user: { email: "test@example.com" }
        expect(response).to render_template :new				
			end
			it "does not charge the card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: { email: "kevin@example.com" }				
			end
			it "does not send out email with invalid inputs" do
				post :create, user: { email: "test@example.com" }				
				expect(ActionMailer::Base.deliveries).to be_empty
			end
		end


	end
end
