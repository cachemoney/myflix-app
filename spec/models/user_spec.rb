require 'spec_helper'

describe User do
  context "basic assertions" do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should have_many(:queue_items).order(:position) }
    it { should have_many(:reviews).order("created_at DESC") }
    it { should have_many(:invites) }

  end

  describe "#follows?" do
  	it "should returns true if the user has a following relationship with another user" do
  		alice = Fabricate(:user)
  		bob = Fabricate(:user)
  		Fabricate(:relationship, leader: bob, follower: alice)
  		expect(alice.follows?(bob)).to be_true
  	end

  	it "returns false if the user doesn not have following relationship with another user" do
  		alice = Fabricate(:user)
  		bob = Fabricate(:user)
  		Fabricate(:relationship, leader: alice, follower: bob)
  		expect(alice.follows?(bob)).to be_false
  	end

    describe "#follow" do
      it "follows another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        alice.follow(bob)
        expect(alice.follows?(bob)).to be_true
      end
      it "doesn't follow one self" do
        alice = Fabricate(:user)
        alice.follow(alice)
        expect(alice.follows?(alice)).to be_false
      end
    end
  end
end