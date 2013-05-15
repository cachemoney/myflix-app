require 'spec_helper'

describe VideosController do
	describe "GET show" do
		
		let(:video1) { Fabricate(:video) }

		it "sets the video var" do
			# futurama = Video.create(title: "Futurama", description: "funny")
			
			get :show, id: video1
			assigns(:video).should == video1
		end
		it "renders the show template" do
			get :show, id: video1.id
			expect(response).to render_template :show 
		end
	end

	describe "GET search" do
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