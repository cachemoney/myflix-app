require 'spec_helper'

describe ReviewsController do
	describe "POST create" do
		let!(:video)	{ Fabricate(:video) }
		before { set_current_user }

		context "Authenticated Users" do
			context "valid reviews" do
				it "creates the review for that video" do
					post :create, review: Fabricate.attributes_for(:review), video_id: video
					expect(video.reviews.count).to eq 1
				end
				it "creates the review for that signed_in user" do
					post :create, review: Fabricate.attributes_for(:review), video_id: video
					expect(video.reviews.first.user).to eq current_user
				end
				it "redirects to the video page" do
					post :create, review: Fabricate.attributes_for(:review), video_id: video
					expect(response).to redirect_to video_path(video)
				end
			end

			context "invalid reviews" do
				it "does not create a review" do
					post :create, review: {rating: 3} , video_id: video
					expect(video.reviews.count).to eq 0
				end

				it "renders the show template" do
					post :create, review: {rating: 3} , video_id: video
					expect(response).to render_template :show
				end 
			end
		end

		context "Unauthenticated users" do
			# before do
			# 	session[:user_id] = nil
			# end

			it_behaves_like "require_sign_in" do
				let(:action) { post :create, review: {rating: 3} , video_id: video }
			end

			it "should not create the review" do
				clear_current_user
				post :create, review: Fabricate.attributes_for(:review), video_id: video
				expect(video.reviews.count).to eq 0				
			end

		end
	end
  
end