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

	describe "search by title" do
		it "returns an empty array if there is no match" do
			futurama = Video.create(title: "Futurama", description: "Time Travel")
			back_to_future = Video.create(title: "Back to thefuture", description: "Time Travel")
			expect(Video.search_by_title("hello")).to eq([])
		end
		it "returns an array of one video for an exact match" do
			futurama = Video.create(title: "Futurama", description: "Time Travel")
			back_to_future = Video.create(title: "Back to thefuture", description: "Time Travel")
			expect(Video.search_by_title("Futurama")).to eq([futurama])
		end
		it "returns an array of one video for a partial match" do
			futurama = Video.create(title: "Futurama", description: "Time Travel")
			back_to_future = Video.create(title: "Back to thefuture", description: "Time Travel")
			expect(Video.search_by_title("urama")).to eq([futurama])
		end
		it "returns an array of all matches ordered by create_at" do
			futurama = Video.create(title: "Futurama", description: "Time Travel", created_at: 1.day.ago)
			back_to_future = Video.create(title: "Back to thefuture", description: "Time Travel")
			expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
		end

		it "returns an empty array for a search with an empty string" do
			futurama = Video.create(title: "Futurama", description: "Time Travel", created_at: 1.day.ago)
			back_to_future = Video.create(title: "Back to thefuture", description: "Time Travel")
			expect(Video.search_by_title("")).to eq([])
		end
	end

end