require 'spec_helper'

describe Invite do
  context "basic assertions" do
    it { should validate_presence_of(:invitee_email) }
		it { should belong_to(:inviter) }
	end
	
end