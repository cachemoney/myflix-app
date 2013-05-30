class Friendship < ActiveRecord::Base
	#join table to associate friends to a user
	belongs_to :user
	belongs_to :friend, :class_name => "User"
end
