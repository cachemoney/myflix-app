require 'spec_helper'

describe Category do
	it { should have_many(:videos) }

	it "should save itself" do
		category = Category.new(title: "Romantic Comedy")
		expect(category).to be_valid
	end

	it "should have title present" do
		expect(Category.new(title: nil)).to have(1).errors_on(:title)
	end

end