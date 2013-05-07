require 'spec_helper'

describe Category do
	it { should have_many(:videos) }

	it "should save itself" do
		category = Category.new(title: "Romantic Comedy")
		expect(category).to be_valid
	end
end