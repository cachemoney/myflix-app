module StripeWrapper
	class Charge
		attr_reader	:response, :status

		def initialize(response, status)
			@response = response
			@status = status
		end

		def self.create(options={})
			begin
				response = Stripe::Charge.create(amount: options[:amount], currency: 'usd', card: options[:card])
				new( response, :success)
			rescue Stripe::CardError => e
				new(e, :error)
			end
		end

		def success?
			status == :success
		end

		def error_message
			response.message
		end
	end

	class Customer
		def initialize(customer)
			@customer = customer
		end

		def self.create(options={})
			customer = Stripe::Customer.create(email: options[:email], card: options[:card] )
		end
	end

end