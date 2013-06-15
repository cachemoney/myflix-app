class Invite < ActiveRecord::Base
	include Tokenable
	validates_presence_of	:invitee_email
	belongs_to	:inviter, class_name: "User"

	before_create	:generate_token


end