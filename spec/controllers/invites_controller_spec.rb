require 'spec_helper'

describe InvitesController do

	describe	"GET new" do
		before { set_current_user }
		it "assigns new invite to @invite" do
		  get :new
		  expect(assigns(:invite)).to be_instance_of(Invite)
		end
		it "should render new template" do
			get :new
			expect(response).to render_template :new
		end
	end


	describe "POST create" do
		context "with valid inputs" do
			before do
				set_current_user
				ActionMailer::Base.deliveries = []
			end

		  it "creates new Invite" do
		  	post :create, invites: Fabricate.attributes_for(:invite)
		  	expect(Invite.count).to eq (1)
		  end
		  it "sends out Invite email" do
		  	post :create, invites: Fabricate.attributes_for(:invite)
		  	ActionMailer::Base.deliveries.should_not be_empty	
		  end
		  it "redirects to root path after submit" do
		  	post :create, invites: Fabricate.attributes_for(:invite)
		  	expect(response).to redirect_to root_path
		  end
		  it "doesnt create invite on someone elses behalf" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        session[:user_id] = alice.id
        invitation = Fabricate(:invite, inviter: bob)

        # expect(invitation.inviter).not_to eq(bob)
        expect(Invite.count).to eq 0
		  end
		end
	end
end