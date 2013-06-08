class User < ActiveRecord::Base
	validates_presence_of	:email, :password, :full_name
	validates_uniqueness_of	:email

	has_secure_password
	has_many	:queue_items, order: :position
	has_many	:reviews, order: "created_at DESC"
	has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
	has_many	:leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  def reorder_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index+1)
    end
  end

  def follows?(another_user)
  	following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
		!(self.follows?(another_user) || self == another_user)
  end



# new stufff.....................

  def set_password_reset_token
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.save(validate: false)
  end

  def set_password_reset_sent_at
    self.password_reset_sent_at = Time.zone.now
    self.save(validate: false)
  end

  def reset_password(new_password)
    self.password = new_password
    self.password_reset_token = ""
    self.save
  end





end