class Relationship < ActiveRecord::Base
	#join table to associate friends to a user
	belongs_to :follower, class_name: "User"
	belongs_to :leader, class_name: "User"
end
