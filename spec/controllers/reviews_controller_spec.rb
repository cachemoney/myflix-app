require 'spec_helper'

describe ReviewsController do
	describe "POST create" do
		context "valid reviews" do
			it "creates the review for that video" do
				video = Fabricate(:video)
				post :create, review: Fabricate.attributes_for(:review), video_id: video
				expect(video.reviews.count).to eq 1
			end

			it "redirects to the video page" do
				video = Fabricate(:video)
				post :create, review: Fabricate.attributes_for(:review), video_id: video
				expect(response).to redirect_to video_path(video)
			end
		end

		context "invalid reviews" do
			it "does not create a review" do
				video = Fabricate(:video)
				post :create, review: {rating: 3} , video_id: video
			end

			it "renders the show template" do
				video = Fabricate(:video)
				post :create, review: {rating: 3} , video_id: video
				expect(video.reviews.count).to eq 0

			end
		  
		end

		context "Unauthenticated users" do
			it "redirects to the sign in path" do
				video = Fabricate(:video)
				post :create, review: {rating: 3} , video_id: video				
				expect(response).to redirect_to sign_in_path
			end
			it "should not create the review"

		end
	end
  
end