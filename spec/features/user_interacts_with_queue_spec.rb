require 'spec_helper'

feature "User interacts with the queue" do
	scenario "user adds and reorders videos in the queue" do
		comedies = Fabricate(:category)
		monk = Fabricate(:video, title: "Monk", category: comedies)
		south_park = Fabricate(:video, title: "South Park", category: comedies)
		futurama = Fabricate(:video, title: "Futurama", category: comedies)

		sign_in
		find("a[href='/videos/#{monk.id}']").click
		page.should have_content(monk.title)

		click_link "+ My Queue"
		page.should have_content(monk.title)

		visit video_path(monk)
		page.should_not have_content "+ My Queue"

		add_video_to_queue(south_park)
		add_video_to_queue(futurama)

		
		set_video_position(monk,3)
		set_video_position(south_park,1)
		set_video_position(futurama,2)

		click_button "Update Instant Queue"

		expect(find("#video_#{south_park.id}").value).to eq("1")
		expect(find("#video_#{monk.id}").value).to eq("3")
		expect(find("#video_#{futurama.id}").value).to eq("2")
	end

# helper methods

	def add_video_to_queue(video)
		visit home_path
		find("a[href='/videos/#{video.id}']").click
		click_link "+ My Queue"		
	end

	def set_video_position(video, position)
		fill_in "video_#{video.id}", with: position
	end
end