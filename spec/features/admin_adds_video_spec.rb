require 'spec_helper'

feature "Admin adds video" do
	scenario "testing adding video and verfying it works" do
		alice_admin = Fabricate(:user, admin: true)
		sign_in(alice_admin)
		visit new_admin_video_path
		page.should have_css("a", text: "Add a New Video")
		fill_in  "video[title]", with: "Game Of Thrones"
		page.select( "2", from: "video[category_id]")
	end
end