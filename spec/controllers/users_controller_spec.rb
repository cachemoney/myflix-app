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
	
	describe "POST create" do
		# let(:user1){ Fabricate.build(:user) }

		context "with valid parameters" do
			before { post :create, user: Fabricate.attributes_for(:user) }

			it "creates new user" do
        expect(User.count).to eq (1)
      end				
			it "logs user in automatically" do
				expect(session[:user_id]).to_not eq nil
			end
			it "redirects to home_path" do
				expect(response).to redirect_to home_path
			end
		end
		context "email sending" do
			let!(:alice)	{Fabricate.attributes_for(:user)}
			before do
			 post :create, user: alice
			end

			it "sends out the email" do
				ActionMailer::Base.deliveries.should_not be_empty
			end
			it "sends to the right receipient" do
				message = ActionMailer::Base.deliveries.last
				message.to.should == [alice["email"]]
			end
			it "has the right content" do
				message = ActionMailer::Base.deliveries.last
				message.body.should include('You have successfully signed up to example.com')
			end
		end

		context "with invalid parameters" do
			before { post :create, user: {email: "test@example.com" } }

			it "does not create new user" do
				expect(User.count).to eq (0)
			end
			it "doest not login the user" do
				expect(session[:user_id]).to eq nil
			end
			it "renders the new template" do
				expect(response).to render_template :new
			end
		end

	end
end