require 'spec_helper'

describe FriendshipsController do
	describe "GET Index" do
		before { set_current_user }
		context "Authenticated users" do
			it "renders the index template" do
				get  :index
				expect(response).to render_template(:index)
			end
		end

		it_behaves_like "require_sign_in" do
			let(:action) {get :index}
		end
	end

	describe "GET delete" do
		before { set_current_user }
		it "removes a friend from the current user" do
			bob = Fabricate(:user)
			jon = Fabricate(:user)
			alice = current_user
			friendship1 = Fabricate(:friendship, user: alice, friend: bob)
			friendship2 = Fabricate(:friendship, user: alice, friend: jon)
			delete :destroy, id: jon.id
			expect(alice.friends).not_to include(jon)
		end

		it "redirects to people_path" do
			bob = Fabricate(:user)
			jon = Fabricate(:user)
			alice = current_user
			friendship1 = Fabricate(:friendship, user: alice, friend: bob)
			friendship2 = Fabricate(:friendship, user: alice, friend: jon)
			delete :destroy, id: jon.id
			expect(response).to redirect_to people_path
		end
	end

	describe "GET create" do
		before { set_current_user }
		it "adds a user to current user friends" do
			bob = Fabricate(:user)
			alice = current_user

			post :create, friend_id: bob.id
			expect(alice.friends).to include(bob)
		end
		it "redirectes to the friends page after adding a friend" do
			bob = Fabricate(:user)
			alice = current_user

			post :create, friend_id: bob.id
			expect(response).to redirect_to people_path		
		end

		it "displays flash notice on a successful friend follow" do
			bob = Fabricate(:user)
			alice = current_user

			post :create, friend_id: bob.id
			expect(flash[:notice]).to be_present			
		end
	end

end