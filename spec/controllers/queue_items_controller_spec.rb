require 'spec_helper'

describe QueueItemsController do

	describe "GET Index" do
	  it "sets the queue items of the current logged in user" do
	    alice = Fabricate(:user)
	    session[:user_id] = alice.id
	    queue_item1 = Fabricate(:queue_item, user: alice)
	    queue_item2 = Fabricate(:queue_item, user: alice)
	    get :index
	    expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
	  end
	  
	  it "redirects to the sign in page for unauthenticated user" do
	  	get :index
	  	expect(response).to redirect_to sign_in_path
	  end
	end

	describe "#POST create" do
		context "Authenticated users" do
			let(:alice) { Fabricate(:user) }
			before { session[:user_id] = alice.id }

			it "redirects to the my_queue page" do
				video = Fabricate(:video)
				post :create, video_id: video.id
				expect(response).to redirect_to my_queue_path
			end
			it "creates queue_item associated with the video" do
				video = Fabricate(:video)
				post :create, video_id: video.id
				expect(QueueItem.first.video).to eq(video)
		end

			it "creates the queue item associated with current user" do
				video = Fabricate(:video)
				post :create, video_id: video.id
				expect(QueueItem.first.user).to eq(alice)
			end
			it "doesnt create queue_item if video is already in queue" do
				monk = Fabricate(:video)
				Fabricate(:queue_item, video: monk, user: alice)
				post :create, video_id: monk.id
				expect(QueueItem.count).to eq(1)
			end
			it "puts the video in the last position" do
				monk = Fabricate(:video)
				south_park = Fabricate(:video)
				Fabricate(:queue_item, video: monk, user: alice)
				post :create, video_id: south_park.id
				south_park_queue_item = QueueItem.where(video_id: south_park.id).first
				expect(south_park_queue_item.position).to eq(2)
			end
		end
		context "unauthenticated users" do
			it "should redirect to sign_in page" do
				post :create, video_id: 4
				expect(response).to redirect_to(sign_in_path)
			end
		end
	end

	describe "#POST destroy" do
		context "Authenticated users" do
			let(:alice) { Fabricate(:user) }
			let(:video)	{Fabricate(:video) }
			before { session[:user_id] = alice.id }

			it "redirects to the my_queue page" do
				video = Fabricate(:video)
				queue_item1 = Fabricate(:queue_item, video: video, user: alice)
				post :destroy, id: queue_item1.id
				expect(response).to redirect_to my_queue_path
			end

			it "it removes the queue_item " do
				video = Fabricate(:video)
				queue_item1 = Fabricate(:queue_item, video: video, user: alice)
				post :destroy, id: queue_item1.id
				expect(QueueItem.count).to eq(0)
			end

		end

		context "unauthenticated users" do
			it "should redirect to sign_in page" do
				post :destroy, id: 1
				expect(response).to redirect_to(sign_in_path)
			end
		end		
	end
	describe "POST update_queue" do
		context "with valid input" do
			it "reorders queue_items " do
				alice = Fabricate(:user)
				session[:user_id] = alice.id
				queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
				queue_item2 = Fabricate(:queue_item, position: 2, user: alice)
				post :update_queue,	queue_items: [{id: queue_item1.id, position: 2}, 
					{id: queue_item2.id, position: 1}]
					expect(alice.queue_items).to eq([queue_item2, queue_item1])
			end
			it "normalizes the position numbers" do
				alice = Fabricate(:user)
				session[:user_id] = alice.id
				queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
				queue_item2 = Fabricate(:queue_item, position: 2, user: alice)
				post :update_queue,	queue_items: [{id: queue_item1.id, position: 3}, 
					{id: queue_item2.id, position: 2}]
				expect(queue_item1.reload.position).to eq(2)
				expect(queue_item2.reload.position).to eq(1)
			end
			it "redirect_to to my_queue page" do
				alice = Fabricate(:user)
				session[:user_id] = alice.id
				queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
				queue_item2 = Fabricate(:queue_item, position: 2, user: alice)
				post :update_queue,	queue_items: [{id: queue_item1.id, position: 2}, 
					{id: queue_item2.id, position: 1}]
				expect(response).to redirect_to(my_queue_path)
			end
		end

		context "with invalid input" do
			it "does not change queue_items" do
				alice = Fabricate(:user)
				session[:user_id] = alice.id
				queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
				queue_item2 = Fabricate(:queue_item, position: 2, user: alice)
				post :update_queue,	queue_items: [{id: queue_item1.id, position: 3.5}, 
					{id: queue_item2.id, position: 1}]
				expect(alice.queue_items).to eq([queue_item1, queue_item2])
			end
			it "redirects to my_queue_path" do
				alice = Fabricate(:user)
				session[:user_id] = alice.id
				queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
				queue_item2 = Fabricate(:queue_item, position: 2, user: alice)
				post :update_queue,	queue_items: [{id: queue_item1.id, position: 3.5}, 
					{id: queue_item2.id, position: 1}]
				expect(response).to redirect_to(my_queue_path)
			end				
			it "sets the error flash" do
				alice = Fabricate(:user)
				session[:user_id] = alice.id
				queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
				queue_item2 = Fabricate(:queue_item, position: 2, user: alice)
				post :update_queue,	queue_items: [{id: queue_item1.id, position: 3.5}, 
					{id: queue_item2.id, position: 1}]
				expect(flash[:error]).to be_present
			end
		end
		context "unauthenticated user" do
			it "redirects to sign in path" do
				post :update_queue, queue_items: [{id: 2, position: 3}, {id: 3, position: 2}]
				expect(response).to redirect_to(sign_in_path)
			end
		end
		context "queue items not belonging to current user" do
			it "does not change position of other's queue items" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, position: 1, user: alice)
        queue_item2 = Fabricate(:queue_item, position: 2, user: bob)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(bob.queue_items.first.position).to eq(2)				
			end
		end
		  
	end
end