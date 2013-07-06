require 'spec_helper'

describe StripeWrapper::Charge do
	let(:token) do
		Stripe::Token.create(
		  :card => {
		  	:number => card_number,
		  	:exp_month => 3,
		  	:exp_year	=> 2016,
		  	:cvc	=> 123
		  	},
		).id
	end

	context "with valid card" do
		let(:card_number) {'4242424242424242'}
		it "charges the card successfully", :vcr do
			response = StripeWrapper::Charge.create(amount: 400, card: token)
			expect(response).to be_success
		end
	end

	context "with invalid", :vcr do
	  let(:card_number) {'4000000000000002'}
	  let(:response) { StripeWrapper::Charge.create(amount: 400, card: token) }

	  it "doesn't charge the card" do
	  	expect(response).to_not be_success
	  end
	  it "contains and error response message" do
	  	expect(response.error_message).to eq('Your card was declined.')
	  end
	end
end