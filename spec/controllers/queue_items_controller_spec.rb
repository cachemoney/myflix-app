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

end