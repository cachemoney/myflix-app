class Invite < ActiveRecord::Base
	validates_presence_of	:invitee_email
	belongs_to	:inviter, class_name: "User"

	before_create	:generate_token

	def generate_token
		self.token = SecureRandom.urlsafe_base64	
	end

end