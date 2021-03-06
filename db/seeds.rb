# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

movies = [
	["Family Guy", "Show about the Griffin Family in Quahog", "family_guy.jpg", "monk_large.jpg"],
	["Futurama", "Matt Groeings master creation", "futurama.jpg", "monk_large.jpg"],
	["Monk", "Silly Detective and his attempt to solve cases", "monk.jpg", "monk_large.jpg"],
	["South Park", "Gang of misfit kids and their adventures in a small Colorado town", "south_park.jpg", "monk_large.jpg"]
]

categories = %w( Action\ &\ Adventure Animation Comedy Documentary Drama 
								Family\ &\ Kids Foreign Horror Music\ &\ Performing Arts Mystery\ &\ Suspense 
								Romance Sci-Fi\ &\ Fantasy Special Interest Sports\ &\ Fitness War Western)

users = []
(0..10).each do 
  users.tap {|ary| ary << User.create(full_name: Faker::Name.name, email: Faker::Internet.email, password: 'password')}
end

reviews = []
(1..25).each do |v|
  reviews.tap {|ary| ary << Review.create(content: Faker::Lorem.paragraph(3), rating: [*1..5].sample, user: users[v%11], video_id: rand(1..movies.count))}
end

trailer_url = ["http://www.tools4movies.com/dvd_catalyst_profile_samples/Harold%20Kumar%203%20Christmas%20bionic%20hq.mp4",
							"http://www.tools4movies.com/dvd_catalyst_profile_samples/The%20Amazing%20Spiderman%20bionic%20hq.mp4",
							"http://www.tools4movies.com/dvd_catalyst_profile_samples/Twilight%204%20Breaking%20Dawn%20bionic%20hq.mp4"]

videos = []
movies.each do |title, description, small_url, large_url|
  videos.tap {|ary| ary << Video.create(title: title, description: description, small_cover_url: File.open(File.join(Rails.root, "/public/uploads/video/small_cover_url/#{small_url}")), 
  	large_cover_url: File.open(File.join(Rails.root, "/public/uploads/video/large_cover_url/#{large_url}")), category_id: rand(1..(categories.count)),
    					video_url: trailer_url.sample)}
end

categories.each do |category|
	Category.create(title: category)
end

robin = User.create(full_name: "Robin Paul", email: "robin@example.com", password: "password", admin: true)

friendships = []
(1..5).each do |i|
	# friendships.tap {|ary| ary << Friendship.create(user: robin, friend: users[i%10]) }
end
users << robin

queue_items = []
users.each do |user|
	queue_items.tap { |ary| ary << QueueItem.create(video_id: rand(1..movies.count), position: 1, user: user) }
end


