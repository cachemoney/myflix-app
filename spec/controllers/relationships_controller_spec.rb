require 'spec_helper'

describe RelationshipsController do
	describe "GET Index" do

		it "sets @relationship for current user's following relationship" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: alice, leader: bob )
			get :index
			expect(assigns(:relationships)).to eq([relationship])
		end

		it_behaves_like "require_sign_in" do
			let(:action) {get :index}
		end


	end

	describe "GET delete" do
		it_behaves_like "require_sign_in" do
			let(:action) {delete :destroy, id: 4}
		end
		it " redirectes to the people page" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: alice, leader: bob )
			delete :destroy, id: relationship
			expect(response).to redirect_to people_path
		end
		it "deletes the relationship if the current user is the follower" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: alice, leader: bob )
			delete :destroy, id: relationship
			expect(Relationship.count).to eq 0
		end

		it "doesnt delete the relatioship if the current user is not the follower" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			charlie = Fabricate(:user)
			relationship = Fabricate(:relationship, follower: charlie, leader: bob )
			delete :destroy, id: relationship
			expect(Relationship.count).to eq 1
		end
	end

	# describe "GET create" do
	# 	before { set_current_user }
	# 	it "adds a user to current user friends" do
	# 		bob = Fabricate(:user)
	# 		alice = current_user

	# 		post :create, friend_id: bob.id
	# 		expect(alice.friends).to include(bob)
	# 	end
	# 	it "redirectes to the friends page after adding a friend" do
	# 		bob = Fabricate(:user)
	# 		alice = current_user

	# 		post :create, friend_id: bob.id
	# 		expect(response).to redirect_to people_path		
	# 	end

	# 	it "displays flash notice on a successful friend follow" do
	# 		bob = Fabricate(:user)
	# 		alice = current_user

	# 		post :create, friend_id: bob.id
	# 		expect(flash[:notice]).to be_present			
	# 	end
	# end

end