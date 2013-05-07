require 'spec_helper'

describe Video do
	it "saves itself" do
		video = Video.new(title: "test movie title", description: "test desc", 
			small_cover_url: "small.jpg", large_cover_url: "large.jpg",
			category_id: 5)
		video.save
		Video.first.title.should eq ("test movie title")
	end

	it { should belong_to (:category) }

	it "should have title present" do
		expect(Video.new(title: nil)).to have(1).errors_on(:title)
	end

	it "should have description present" do
		expect(Video.new(description: nil)).to have(1).errors_on(:description)
	end

end