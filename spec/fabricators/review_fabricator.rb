Fabricator(:review) do
	rating 3
	content	{ Faker::Lorem.paragraph(3) }
end