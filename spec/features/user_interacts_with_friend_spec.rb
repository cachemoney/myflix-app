require 'spec_helper'

feature "User uses friend social features" do
	scenario "User adds and deletes a friend" do
		comedies = Fabricate(:category)
		monk = Fabricate(:video, title: "Monk", category: comedies)
		jon_friend = Fabricate(:user)
		review = Fabricate(:review, user: jon_friend, video: monk)
		alice = Fabricate(:user)

		sign_in(alice)
		# visit the monk video page
		find("a[href='/videos/#{monk.id}']").click
		page.should	have_content(jon_friend.full_name)

		find("a[href='/users/#{jon_friend.id}']").click
		page.should have_content("#{jon_friend.full_name}'s video collections")
		page.should have_button("Follow")

		click_link "Follow"
		current_path.should eq people_path
		page.should	have_content(jon_friend.full_name)

		find("a[href='/friendships/#{jon_friend.id}']").click
		within('tr') do
			page.should_not have_content(jon_friend.full_name)
		end
	end

end