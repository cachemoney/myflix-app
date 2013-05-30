class User < ActiveRecord::Base
	validates_presence_of	:email, :password, :full_name
	validates_uniqueness_of	:email

	has_secure_password
	has_many	:queue_items, order: :position
	has_many	:reviews, order: :created_at
	has_many :friendships
	has_many :friends, :through => :friendships 

  def reorder_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end
end