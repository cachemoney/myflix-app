require 'spec_helper'

describe "QueueItem" do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
    
  describe "#video_title" do
    it "returns the title of the video" do
    	video = Fabricate(:video, title: "South Park")
    	queue_item = Fabricate(:queue_item, video: video)
    	expect(queue_item.video_title).to eq("South Park")
    end
  end
end