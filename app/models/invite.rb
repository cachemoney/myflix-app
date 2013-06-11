class Invite < ActiveRecord::Base
	validates_presence_of	:invitee_email
	belongs_to	:inviter, class_name: "User"
end