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


	describe "POST create" do
		it_behaves_like "require_sign_in" do
			let(:action) {post :create, leader_id: 4}
		end

		it "redirects to the people_page" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			post :create, leader_id: bob.id
			expect(response).to redirect_to people_path
		end

		it "creates a relationship that the current user follows the leader" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			post :create, leader_id: bob.id
			expect(alice.following_relationships.first.leader).to eq(bob)
		end

		it "the current signed in user cant follow the same user twice" do
			alice = Fabricate(:user)
			set_current_user(alice)
			bob = Fabricate(:user)
			Fabricate(:relationship, leader: bob, follower: alice)
			post :create, leader_id: bob.id
			expect(Relationship.count).to eq(1)
		end

		it "doesnt now allow current_user to follow themselves" do
			alice = Fabricate(:user)
			set_current_user(alice)
			post :create, leader_id: alice.id			
			expect(Relationship.count).to eq(0)
		end
	end


end