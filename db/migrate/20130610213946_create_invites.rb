class CreateInvites < ActiveRecord::Migration
  def change
  	create_table	:invites do |t|
  		t.integer	:inviter_id
  		t.string	:invitee_email

  		t.timestamps
  	end
  end

end
