require 'spec_helper'

describe "QueueItem" do
  # it { should belong_to(:user) }
  # it { should belong_to(:video) }
    
  describe "#video_title" do
    it "returns the title of the video" do
    	video = Fabricate(:video, title: "South Park")
    	queue_item = Fabricate(:queue_item, video: video)
    	expect(queue_item.video_title).to eq("South Park")
    end
  end

  describe "#rating" do
  	it "should display rating review if the user has a rating on the vide" do
  		alice = Fabricate(:user)
  		monk = Fabricate(:video)
  		review = Fabricate(:review, user: alice, video: monk, rating: 4)
  		queue_item = Fabricate(:queue_item, user: alice, video: monk)
  		expect(queue_item.rating).to eq(4)
  	end

  	it "if the user doesnt have review on the video, returns nil" do
  		alice = Fabricate(:user)
  		monk = Fabricate(:video)
  		queue_item = Fabricate(:queue_item, user: alice, video: monk)
  		expect(queue_item.rating).to be_nil  	
  	end
  end
  describe "rating#" do
    it "changes the rating of the review if the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item1 = Fabricate(:queue_item, user: user, video: video)
      queue_item1.rating = 4
      expect(Review.first.rating).to eq(4) #this forces a db lookup, otherwise it'd have to be review.reload.rating
    end
    it "can also clear the rating of the review if a review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item1 = Fabricate(:queue_item, user: user, video: video)
      queue_item1.rating = nil
      expect(Review.first.rating).to be_nil
    end
    it "will create the review with a rating if the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: user, video: video)
      queue_item1.rating = 3  
      expect(Review.first.rating).to eq(3)

    end
  end

  describe "#category_name" do
  	it "returns the category of a video " do
  		dramas = Fabricate(:category, title: "dramas")
  		monk = Fabricate(:video, category: dramas)
  		queue_item = Fabricate(:queue_item, video: monk)
  		expect(queue_item.category_name).to eq("dramas")
  	end
  end

    describe "#category" do
    	it "returns the category object of a video" do
	  		dramas = Fabricate(:category, title: "dramas")
	  		monk = Fabricate(:video, category: dramas)
	  		queue_item = Fabricate(:queue_item, video: monk)
	  		expect(queue_item.category).to eq(dramas)    		
    	end
    end
end