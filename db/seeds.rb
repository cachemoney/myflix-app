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

movies.each do |title, description, small_url, large_url|
  Video.create(title: title, description: description, category_id: rand(1..(categories.count)),
  	small_cover_url: small_url, large_cover_url: large_url)
end

categories.each do |category|
	Category.create(title: category)
end