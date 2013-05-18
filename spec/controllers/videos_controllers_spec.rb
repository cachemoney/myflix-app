require 'spec_helper'

describe VideosController do
	describe "GET show" do
		context "Authenticated User" do
		  before do
			  alice = Fabricate(:user)
			  session[:user_id] = alice.id
			end

			let(:video1) { Fabricate(:video) }

			it "sets the video var" do
				# futurama = Video.create(title: "Futurama", description: "funny")
				
				get :show, id: video1
				assigns(:video).should == video1
			end
			it "sets @reviews for the authenticated" do
				review1 = Fabricate(:review, video: video1)
				review2 = Fabricate(:review, video: video1)
				get :show, id: video1.id
				expect(assigns(:reviews)).to include(review1, review2)
			end

			it "renders the show template" do
				get :show, id: video1.id
				expect(response).to render_template :show 
			end
		end
	end
		describe "GET search" do
		context "Authenticated User" do
		  before do
			  alice = Fabricate(:user)
			  session[:user_id] = alice.id
			end

				let(:video1) { Fabricate(:video) }

				it "should assign search results to var" do
					get :search, search_term: "game"
					assigns(:results).should == [video1]
				end

				it "should render search template" do
					get :search, search_term: "game"
					expect(response).to render_template :search
				end
			end
		end
end