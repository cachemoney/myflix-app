require 'spec_helper'

describe UsersController do

	describe "GET new" do
		# let(:user1){ Fabricate(:user) }

		it "assign new user to @user " do
			get :new
			expect(assigns(:user)).to be_a_new(User)
		end
		it "should render new template" do
			get :new
			expect(response).to render_template :new
		end
	end
	
	describe "POST create" do
		let(:user1){ Fabricate.build(:user) }

		context "with valid parameters" do
			it "saves user to db" do
				post :create, Fabricate.attributes_for(:user)
        expect(User.count).to eq (1)
      end				
			it "logs user in automatically"
			it "redirects to home_path"
		end

		context "with invalid parameters" do
			it "does not save to db"
			it "doest not login the user"
			it "renders the new template"
		end

	end
end