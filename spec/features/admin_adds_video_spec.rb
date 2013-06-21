require 'spec_helper'

feature "Admin adds video" do
	scenario "testing adding video and verfying it works" do
		alice_admin = Fabricate(:user, admin: true)
		comedy = Fabricate(:category, title: "Comedy")
		video = Fabricate.attributes_for(:video, 
			description: "test data",
			large_cover_url: "#{Rails.root}/app/assets/images/monk_large.jpg",
			small_cover_url: "#{Rails.root}/public/uploads/video/small_cover_url/homeland.jpg",
			video_url: "http://www.tools4movies.com/dvd_catalyst_profile_samples/Twilight%204%20Breaking%20Dawn%20bionic%20hq.mp4")
		sign_in(alice_admin)
		visit new_admin_video_path
		page.should have_css("a", text: "Add a New Video")
		fill_in  "video[title]", with: "Game of Thrones"
		page.select( comedy.title, from: "video[category_id]")
		fill_in  "video[description]", with: video["description"]
		attach_file("video[large_cover_url]", video["large_cover_url"])
		attach_file("video[large_cover_url]", video["small_cover_url"] )
		fill_in  "video[video_url]", with: video["video_url"]
		click_button('Add Video')
		page.should have_css("#flash_success", text: "You have successfull saved Game of Thrones, enter another one")
		saved_video = Video.last
		visit video_path(saved_video)
		element = page.first(:css, "video")
		expect(element[:src]).to eq(saved_video.video_url)
		expect(element[:poster].to_s).to eq(saved_video.large_cover_url.to_s)
		
	end
end