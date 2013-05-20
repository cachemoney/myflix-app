require 'spec_helper'

describe User do
  context "basic assertions" do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:email) }
  end
end