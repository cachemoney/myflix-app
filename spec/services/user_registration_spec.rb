require 'spec_helper'

describe UserRegistration do
	describe "#user_register" do
		context "valid personal info and valid card" do
			let(:charge) { double(:charge, success?: true) }

			before do
				StripeWrapper::Charge.should_receive(:create).and_return(charge)
			end
			after { ActionMailer::Base.deliveries.clear }

			it "creates new user" do
				UserRegistration.new(Fabricate.build(:user)).register_user("stripe_token", nil)
        expect(User.count).to eq (1)
      end

			it "makes the user follow the inviter" do
				alice = Fabricate(:user)
				invitation = Fabricate(:invite, inviter: alice, invitee_email: 'bob@example.com')
				UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'bob doe')).register_user("stripe_token", invitation.token)
				bob = User.where(email: 'bob@example.com').first
				expect(bob.follows?(alice)).to be_true
			end

			it "makes the inviter follow the user" do
				alice = Fabricate(:user)
				invitation = Fabricate(:invite, inviter: alice, invitee_email: 'bob@example.com')
				UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'bob doe')).register_user("stripe_token", invitation.token)
				bob = User.where(email: 'bob@example.com').first
				expect(alice.follows?(bob)).to be_true
			end

			it "expires the the invite when invitee registers" do
				alice = Fabricate(:user)
				invitation = Fabricate(:invite, inviter: alice, invitee_email: 'bob@example.com')
				UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com', password: 'password', full_name: 'bob doe')).register_user("stripe_token", invitation.token)
				expect(Invite.first.token).to be_nil
			end
			
			# Test emails being sent

			it "sends out the email" do
				UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com')).register_user("stripe_token", nil)
				ActionMailer::Base.deliveries.should_not be_empty
			end
			it "sends to the right receipient" do
				UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com')).register_user("stripe_token", nil)
				message = ActionMailer::Base.deliveries.last
				expect(message.to).to eq(["bob@example.com"])
			end
			it "has the right content" do
				UserRegistration.new(Fabricate.build(:user, email: 'bob@example.com')).register_user("stripe_token", nil)
				message = ActionMailer::Base.deliveries.last
				message.body.should include('You have successfully signed up to example.com')
			end
		end
		
		context "valid personal info and declined card" do
			it "does not create a new user record" do
				charge = double(:charge, success?: false, error_message: "Your card was declined.")
				StripeWrapper::Charge.should_receive(:create).and_return(charge)
				UserRegistration.new(Fabricate.build(:user)).register_user("11111111", nil)
				expect(User.count).to eq(0)
			end
		end

		context "with invalid parameters" do
			after { ActionMailer::Base.deliveries.clear }

			it "does not create new user" do
				UserRegistration.new(User.new(email: "alice@example.com")).register_user("11111111", nil)
				expect(User.count).to eq (0)
			end

			it "doesn't charge the card" do
				StripeWrapper::Charge.should_not_receive(:create)
				UserRegistration.new(User.new(email: "alice@example.com")).register_user("11111111", nil)
			end

			it "doesnt send out the email" do
				UserRegistration.new(User.new(email: "alice@example.com")).register_user("11111111", nil)
				expect(ActionMailer::Base.deliveries).to be_empty
			end
		end

	end

end