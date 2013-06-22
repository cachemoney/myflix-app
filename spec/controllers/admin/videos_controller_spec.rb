require 'spec_helper'

describe	Admin::VideosController do
	describe "GET new" do
		it_behaves_like "require_sign_in" do
			let(:action) {get :new}			
		end
		it "sets @video to new video" do
			set_current_admin
			get :new
			expect(assigns(:video)).to be_instance_of Video
			expect(assigns(:video)).to be_new_record
		end
		it "redirects the regular user to the home path" do
			set_current_user
			get :new
			expect(response).to redirect_to home_path
		end
		it "sets the flash error message for regular user" do
			set_current_user
			get :new
			expect(flash[:error]).to be_present
		end
	end

	describe "POST create" do
		before { set_current_admin }
		let!(:category) {Fabricate(:category)}
		let!(:monk) { Fabricate.attributes_for(:video) }

		it_behaves_like "require_sign_in" do
			let(:action) {post :create}
		end
		it_behaves_like "require_admin" do
			let(:action) {post :create}
		end

		context "with valid input" do

			it "creates a video" do
				post :create, video: { title: monk[:title], category_id: category.id, description: monk[:description] }
				expect(category.videos.count).to eq 1
			end

			it "redirects to new video page" do
				post :create, video: { title: monk[:title], category_id: category.id, description: monk[:description] }
				expect(response).to redirect_to new_admin_video_path
			end
			it "sets flash success message" do
				post :create, video: { title: monk[:title], category_id: category.id, description: monk[:description] }
				expect(flash[:success]).to be_present
			end
		end

		context "with invalid input" do
			it "doesnt not add video" do
				post :create, video: { category_id: category.id, description: monk[:description] }
				expect(category.videos.count).to eq 0				
			end

			it "renders the :new template" do
				post :create, video: { category_id: category.id, description: monk[:description] }
				expect(response).to render_template :new
			end
			it "sets the @video variable" do
				post :create, video: { category_id: category.id, description: monk[:description] }
				expect(assigns(:video)).to be_present
			end
			it "sets the flash error message" do
				post :create, video: { category_id: category.id, description: monk[:description] }
				expect(flash[:error]).to be_present
			end
		end

	end
end